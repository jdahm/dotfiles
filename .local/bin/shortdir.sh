#!/bin/sh

ncols=40 # not to exceed ncols
spacer="..."

if [ "${PWD:0:${#HOME}}" == "$HOME" ]; then
	prefix="~/"
	suffix=${PWD:${#HOME}+1}
else
	prefix="/"
	suffix=${PWD:1}
fi

str=$prefix$suffix

if [ ${#str} -gt $ncols ]; then
	# Need to truncate
	i=0
	while [ $i -lt ${#suffix} ]; do
		[ ${suffix:$i:1} == "/" ] \
			&& [ $((${#suffix}-$i-1 + ${#spacer}+${#prefix})) -le $ncols ] \
			&& break
		i=$(($i+1))
	done
	suffix=${suffix:$i+1}
	if [ "$suffix" != "" ]; then
		str=$prefix$spacer${suffix}
	fi
fi

echo $str
