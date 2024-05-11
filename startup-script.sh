#!/bin/bash

# Load 'msr' module
/sbin/modprobe msr

# Read MSR_POWER_CTL register values in hexa
msr_hexa=`/usr/sbin/rdmsr 0x1FC`

# Converts to hexa string in format 0x??
msr_hexa_string='0x'$msr_hexa

# Resets ENABLE_BIDIR_PROCHOT (bit 0)
prochot_disabled_value=$(($msr_hexa_string&0xFFFFFE))

# Write intruction to bypass PROCHOT to all CPUs
/usr/sbin/wrmsr 0x1FC $prochot_disabled_value
