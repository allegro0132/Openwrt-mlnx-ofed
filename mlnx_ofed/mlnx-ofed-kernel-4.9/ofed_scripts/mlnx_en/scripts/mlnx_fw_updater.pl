#!/usr/bin/perl
#
# Copyright (c) 2015 Mellanox Technologies. All rights reserved.
#
# This Software is licensed under one of the following licenses:
#
# 1) under the terms of the "Common Public License 1.0" a copy of which is
#	available from the Open Source Initiative, see
#	http://www.opensource.org/licenses/cpl.php.
#
# 2) under the terms of the "The BSD License" a copy of which is
#	available from the Open Source Initiative, see
#	http://www.opensource.org/licenses/bsd-license.php.
#
# 3) under the terms of the "GNU General Public License (GPL) Version 2" a
#	copy of which is available from the Open Source Initiative, see
#	http://www.opensource.org/licenses/gpl-license.php.
#
# Licensee has the right to choose one of the above licenses.
#
# Redistributions of source code must retain the above copyright
# notice and one of the license notices.
#
# Redistributions in binary form must reproduce both the above copyright
# notice, one of the license notices in the documentation
# and/or other materials provided with the distribution.


use strict;
use File::Basename;
use File::Path;
use Term::ANSIColor qw(:constants);
$ENV{"LANG"} = "C";

my $RC = 0;
my $PREREQUISIT = "172";
my $NO_HARDWARE = "171";
my $DEVICE_INI_MISSING = "2";

if ($<) {
	print RED "Only root can run $0", RESET "\n";
	exit $PREREQUISIT;
}
$| = 1;
my $WDIR	= dirname(`readlink -f $0`);
chdir $WDIR;
my $ERROR = "1";

my $TMPDIR  = '/tmp';
my $log = "";
my $hca_self_test = "/usr/bin/hca_self_test.ofed";
my $reset = 0;
my %fw_info = ();
my $arch = `uname -m`;
chomp $arch;
if ($arch =~ /i.86/) {
	$arch = "i686";
}
my $mlxfwmanager_sriov_dis = "mlxfwmanager_sriov_dis_$arch"; # FW bin files without SRIOV.
my $mlxfwmanager_sriov_en = "mlxfwmanager_sriov_en_$arch"; # FW bin files with SRIOV enabled.

my $firmware_directory = "$WDIR/firmware";
my $force_firmware_update = 0;
my $sriov_en = 0;
my $quiet = 0;
my $verbose = 0;


sub update_fw_version_in_hca_self_test
{
	my $dev = shift @_;
	my $fwver = shift @_;
	my @lines;
	open(FWCONF, "$hca_self_test");
	while(<FWCONF>) {
		push @lines, $_;
	}
	close FWCONF;
	open(FWCONF, ">$hca_self_test");
	foreach my $line (@lines) {
		chomp $line;
		if ($line =~ /^$dev/) {
			print FWCONF "$dev=v$fwver\n";
		} else {
			print FWCONF "$line\n";
		}
	}
	close FWCONF;
}

sub logMsg
{
	my $msg = shift @_;
	open (OUT, ">> $TMPDIR/tmplog");
	print OUT "$msg\n";
	close OUT;
}

sub printNlog
{
	my $msg = shift @_;
	print "$msg\n";
	logMsg "$msg";
}

sub printNlogYellow
{
	my $msg = shift @_;
	print YELLOW "$msg", RESET "\n";
	logMsg "$msg";
}

sub printNlogRED
{
	my $msg = shift @_;
	print RED "$msg", RESET "\n";
	logMsg "$msg";
}

#
# update FW on devices
#
sub check_and_update_FW
{
	print BLUE "Attempting to perform Firmware update...", RESET "\n" if not $quiet;

	my $fw_tmp = "$TMPDIR/mlnx.fw.$$";
	mkpath([$fw_tmp]);
	my $cmd = "-L $log -y --sfx-extract-dir $fw_tmp";
	if ($force_firmware_update) {
		$cmd .= " --force";
	}
	if ($quiet) {
		$cmd .= " -o /dev/null";
	}
	if ($sriov_en == 1) {
		$cmd = "$mlxfwmanager_sriov_en $cmd";
		print YELLOW "Note: Will burn SR-IOV enabled firmware only for ConnctX3 devices.", RESET "\n" if (not $quiet);
		print YELLOW "To configure SR-IOV for other devices, please use the 'mstconfig' utility.", RESET "\n\n" if (not $quiet);
	} else {
		$cmd = "$mlxfwmanager_sriov_dis $cmd";
	}

	# loop on Mellanox devices
	my $founddevs = 0;
	print "Running: lspci -d 15b3: -s.0 2>/dev/null | cut -d\" \" -f\"1\"\n" if $verbose;
	for my $ibdev ( `lspci -d 15b3: -s.0 2>/dev/null | cut -d" " -f"1"` ) {
		$founddevs = 1;
		chomp $ibdev;

		# Skip Virtual Functions
		my $devDesc = `lspci -s $ibdev 2>/dev/null`;
		chomp $devDesc;
		if ($devDesc =~ /virtual/i) {
			print "Skipping a Virtual Function: $ibdev\n" if $verbose;
			next;
		}

		print "Running: $mlxfwmanager_sriov_dis --clear-semaphore -d $ibdev > /dev/null 2>&1\n" if $verbose;
		system("$mlxfwmanager_sriov_dis --clear-semaphore -d $ibdev > /dev/null 2>&1");
		print "running $mlxfwmanager_sriov_dis -d $ibdev --query 2>/dev/null | grep PSID: | awk '{print \$NF}'\n" if $verbose;
		my $psid = `$mlxfwmanager_sriov_dis -d $ibdev --query 2>/dev/null | grep PSID: | awk '{print \$NF}'`;
		chomp $psid;
		if (exists $fw_info{$psid} or $psid eq "" or $psid =~ /psid/i) {
			# we have FW for this device,
			# or we couldn't open the device so let it print the error message.
			print "Running: $cmd -d $ibdev\n" if $verbose;
			system("$cmd -d $ibdev");
			if ($? >> 8 or $? & 127) {
				$RC = 1;
			}
			system("/bin/cat $log >> $TMPDIR/tmplog 2>/dev/null");
			system("/bin/rm -f $log >/dev/null 2>&1");
		} else {
			$RC = $DEVICE_INI_MISSING;
			# we don't have FW for this device
			printNlogYellow ("The firmware for this device is not distributed inside Mellanox driver: $ibdev (PSID: $psid)");
			printNlogYellow ("To obtain firmware for this device, please contact your HW vendor.\n");
		}
	}
	system("/bin/mv $TMPDIR/tmplog $log >/dev/null 2>&1");
	rmtree($fw_tmp);

	if (not $founddevs) {
		print "No devices found!\n";
		exit $NO_HARDWARE;
	}

	if (`grep "Query failed" $log 2>/dev/null`) {
		$RC = 1;
	}
	if ($RC) {
		print RED "Failed to update Firmware.", RESET "\n";
		print RED "See $log", RESET "\n";
	}
	if (`grep -E "FW.*N/A" $log 2>/dev/null`) {
		$RC = $DEVICE_INI_MISSING;
	}
	if (`grep -E "Updating FW.*Done" $log 2>/dev/null`) {
		$reset = 1;
	}
}

# get list of available FW and PSIDs
sub init_fw_info
{
	my @content = `$mlxfwmanager_sriov_dis -l 2>/dev/null`;
	foreach my $line ( @content ) {
		chomp $line;
		next if ($line !~ /FW/);
		my $fwver = "";
		if ($line =~ /.*\s([A-Za-z0-9_]+)\s*FW ([0-9.]+)\s.*/) {
			$fw_info{$1} = 1;
			$fwver = $2;
		}
		# update hca_self_test.ofed
		if (-f "$hca_self_test") {
			if ($line =~ /ConnectX-3/ and $line !~ /Pro/) {
				update_fw_version_in_hca_self_test("CX3_FW_NEEDED", $fwver);
			} elsif ($line =~ /ConnectX-3 Pro/) {
				update_fw_version_in_hca_self_test("CX3_PRO_FW_NEEDED", $fwver);
			} elsif ($line =~ /Connect-IB/) {
				update_fw_version_in_hca_self_test("CONNECTIB_FW_NEEDED", $fwver);
			}
		}
	}
}

sub usage
{
	print GREEN;
	print "\n Usage: $0 [OPTIONS]\n";

	print "\n Options";
	print "\n        --force-fw-update             Force firmware update";
	print "\n        --enable-sriov                Burn SR-IOV enabled firmware";
	print "\n                                      - Note: This flag is intended for ConnectX-3 devices only.";
	print "\n                                              To configure SR-IOV for other devices, please use the 'mstconfig' utility.";
	print "\n                                      - Note: Enabling/Disabling SR-IOV in a non-volatile configuration through uEFI or any";
	print "\n                                              other tool (e.g., mstconfig) will override the SR-IOV configuration settings";
	print "\n                                              defined upon mlnx-en firmware upgrade.";
	print "\n        --fw-dir                      Path to firmware directory with mlnxfwmanager files (Default: $firmware_directory)";
	print "\n        --tmpdir                      Change tmp directory. (Default: $TMPDIR)";
	print "\n        --log                         Path to log file (Default: $TMPDIR/mlnx_fw_update.log)";
	print "\n        -v                            Verbose";
	print "\n        -q                            Set quiet - no messages will be printed";
	print RESET "\n\n";
}

## main
while ( $#ARGV >= 0 ) {
	my $cmd_flag = shift(@ARGV);

	if ( $cmd_flag eq "--force-fw-update" ) {
		$force_firmware_update = 1;
	} elsif ( $cmd_flag eq "--fw-dir" ) {
		$firmware_directory = shift(@ARGV);
	} elsif ( $cmd_flag eq "--tmpdir" ) {
		$TMPDIR = shift(@ARGV);
	} elsif ( $cmd_flag eq "--log" ) {
		$log = shift(@ARGV);
	} elsif ( $cmd_flag eq "--enable-sriov" ) {
		$sriov_en = 1;
		$force_firmware_update = 1;
	} elsif ( $cmd_flag eq "-q" ) {
		$quiet = 1;
	} elsif ( $cmd_flag eq "-v" ) {
		$verbose = 1;
	} else {
		&usage();
		exit 1;
	}
}

$log = "$TMPDIR/mlnx_fw_update.log" if ($log eq "");

# set path to the mlxfwmanager
$mlxfwmanager_sriov_dis = "$firmware_directory/$mlxfwmanager_sriov_dis";
$mlxfwmanager_sriov_en = "$firmware_directory/$mlxfwmanager_sriov_en";
if (not -f $mlxfwmanager_sriov_dis or not -f $mlxfwmanager_sriov_en) {
	print "Error: $mlxfwmanager_sriov_dis doesn't exist.\n" if (not -f $mlxfwmanager_sriov_dis and $verbose);
	print "Error: $mlxfwmanager_sriov_en doesn't exist.\n" if (not -f $mlxfwmanager_sriov_en and $verbose);
	print RED "Error: mlxfwmanager doesn't exist! Cannot perform firmware update.", RESET "\n";
	exit $DEVICE_INI_MISSING;
}

init_fw_info();
check_and_update_FW();
print GREEN "Please reboot your system for the changes to take effect.", RESET "\n"  if ($reset and not $quiet);

exit $RC;
