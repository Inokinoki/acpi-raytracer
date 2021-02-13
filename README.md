


# Challenge

ACPI only allows integer values, because it targets to describing the hardware devices, which do not exactly need float or double value. But a ray-tracing generator does. So, the most difficult thing is to import an [IEEE754](https://en.wikipedia.org/wiki/IEEE_754) in my own ACPI implementation, or just use integer to represent float number. (Or simulate ray tracing, can refer to software FPU implementations).

