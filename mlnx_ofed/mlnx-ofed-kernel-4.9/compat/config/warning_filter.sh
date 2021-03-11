#!/bin/bash

log_file=$1

echo_err()
{
	echo -e "$@" 1>&2
}

regEx="(from incompatible pointer type|declared inside parameter list|is deprecated|expects argument of type|discards .const. qualifier|but argument is of type|discards qualifiers from pointer target type|discards ‘const’ qualifier|makes pointer from integer without a cast)"

cat $log_file 1>&2

if (grep -qE "$regEx" $log_file 2>/dev/null); then
	echo_err "warning_filter.sh: treating warnings as errors!"
	grep -E "$regEx" $log_file 1>&2
	exit 1
fi

exit 0
