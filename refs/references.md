# References
- Terminologies: [General Domain Settings](
 https://coderbag.com/product/quickcpu/features/intel/general-domain-settings)

- CPU Manual (page 2-418 Vol. 4): [Intel Architectures Software Developer’s Manual](https://cdrdv2.intel.com/v1/dl/getContent/671200)

# About ENABLE_BIDIR_PROCHOT
Details of modified power control register:
| Address | Register Name | Power Control Register Name | Bitfield |
| --- | --- | --- | --- |
| 0x1FC | MSR_POWER_CTL | ENABLE_BIDIR_PROCHOT | 0 |

> **According to CPU Manual:**
>
> Used to enable or disable the response to PROCHOT# input.
> When set/enabled, the platform can force the CPU to throttle to a
lower power condition such as Pn/Pm by asserting prochot#.
When clear/disabled (default), the CPU ignores the status of the
prochot input signal.
