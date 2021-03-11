#
# Copyright (c) 2017 Mellanox Technologies. All rights reserved.
#
# This Software is licensed under one of the following licenses:
#
# 1) under the terms of the "Common Public License 1.0" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/cpl.php.
#
# 2) under the terms of the "The BSD License" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/bsd-license.php.
#
# 3) under the terms of the "GNU General Public License (GPL) Version 2" a
#    copy of which is available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/gpl-license.php.
#
# Licensee has the right to choose one of the above licenses.
#
# Redistributions of source code must retain the above copyright
# notice and one of the license notices.
#
# Redistributions in binary form must reproduce both the above copyright
# notice, one of the license notices in the documentation
# and/or other materials provided with the distribution.
#
# MLNX_EN uninstall script
if ( grep -E "Ubuntu|Debian" /etc/issue > /dev/null 2>&1); then
	apt-get remove -y `dpkg --list 2>/dev/nulll | grep -E "mstflint|mlnx" | awk '{print $2}' 2>/dev/nulll` > /dev/null
	apt-get remove -y --purge mlnx-en-utils > /dev/null
else
	rpm -e `rpm -qa 2>/dev/nulll | grep -E "mstflint|mlnx.en|mlx.*en" | grep -v '^kernel-module'` > /dev/null
fi

/bin/rm -f $0

echo "MLNX_EN uninstall done"
