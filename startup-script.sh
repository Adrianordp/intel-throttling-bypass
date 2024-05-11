#!/bin/bash

/sbin/modprobe msr
msr_hexa=`/usr/sbin/rdmsr 0x1FC`
msr_hexa_string='0x'$msr_hexa
prochot_disabled_value=$(($msr_hexa_string&0xFFFFFE))
/usr/sbin/wrmsr 0x1FC $prochot_disabled_value
