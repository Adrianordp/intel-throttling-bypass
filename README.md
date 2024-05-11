# Intel throttling bypass

This repository contains source code, instructions, commands and references explaining how to deal with the annoying Intel CPU throttling on Linux systems due to abnormal operation of thermal protection.

The workaround basically consists of resetting a bit on CPU register to disable the bidirectional processor hot (bidir PROCHOT) functionality. You can read more about it in the references in `./refs/`.

This is not essentially a fix for throttling unexpected actions, since the problem probably lies in your hardware, but it will help you keep your CPU working normally if you administrate its temperature level.

Don't forget to read the [Disclaimers](#disclaimers) before executing commands.

## Requirements
Install `msr` module:
```sh
sudo apt update
sudo apt install msr-tools -y
```

## Testing solution before applying
> Optional:
>
> Install `stress` package to perform tests.
> ```sh
> sudo apt install stress
> ```
> Run stress tests with the command:
> ```sh
> stress -c 16 -t 5
> ```

> _All the following operations are reset automatically after reboot._

First, you need to monitor the CPU frequency in real-time:
```sh
watch -n.5 grep MHz /proc/cpuinfo
```
Open some apps or use `stress` commands to verify if your frequencies are restricted to your minimal frequency range. Mine were capped at 400 MHz, for example.

In another terminal, run the commands:
```sh
# Enable msr driver
sudo modprobe msr
# Read CPU register: MSR_POWER_CTL
sudo rdmsr -d 0x1FC
```
Reading register settings must return a decimal number such as:
```
# example output of 'sudo rdmsr -d 0x1FC'
2359389
```
If the number is odd, it means the PROCHOT register (bit 0) - is set. Then subtract 1 (make it even) and input the following command to reset the register 0.

```sh
# Example command to reset PROCHOT register
sudo wrmsr 0x1fc 2359388

# Note: if the problem keeps happening and the number was already even during the first rdmsr command, then your problem might be something else.
```
Now, hopefully, you're all good. Check the frequencies on the first terminal again, performing CPU demanding actions as you did before.

If this solved you problem, move on to [Enabling workaround on reboot](#enabling-bypass-on-reboot) section. If it doesn't, just reboot your computer to undo CPU configurations.

## Enabling bypass on reboot
> First things first! Read the [Disclaimers](#disclaimers) for your own safety. If you agree, install requirements as explained [above in Requirements](#requirements) and proceed to the method.
Clone this repository to a folder you will not delete (preferably your `/home/$(whoami)` folder):
```sh
git clone https://github.com/Adrianordp/intel-throttling-bypass.git /home/$(whoami)/intel-throttling-bypass
```
Then configure the startup script to run automatically after boot:
```sh
(sudo crontab -l ; echo "@reboot /home/$(whoami)/intel-throttling-bypass/startup-script.sh")| sudo crontab -

# If necessary, replace the script path to the correct place where you have the clone
# Be careful to not perform modifications on the script file path. If you do, you'll just have to update the file location in crontab via 'sudo contrab -e'
```

## Disclaimers
The Intel CPU throttling functionality **was originally intended to protect laptops from overheating** by reducing the processor frequency during high demand. 

Unfortunately, this function can be triggered by **false alarms** in certain rare conditions. I'll list a few of these conditions below:
- Batery malfunction
- Power adapter malfunction
- Low quality third-party components for power supply
- Outdated CPU drivers
- Unsuported OS by manufacturer
- BIOS suboptimal configuration

This list goes on and on. As you can see, many of these are power-related issues.

I recommend you to check your CPU core temperature before trying to force any throttling bypass. If you believe you are under a false positive and the core is not overheating at all, then you can proceed with the bypass at your own risk, of course.

Don't perform the bypass if your cooler is not activating and your cores are overheating.

If you are looking for a straight-forward fix, I suggest starting by investigating potential hardware issues (old batteries, broken chargers, inactive coolers etc.) since it is the most commom cause and replacing them with supplementary components from the manufacturer.