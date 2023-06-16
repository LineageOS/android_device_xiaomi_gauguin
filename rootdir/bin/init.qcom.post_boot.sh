#! /vendor/bin/sh

# Copyright (c) 2012-2013, 2016-2020, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`

case "$target" in
    "lito")

    #Apply settings for lito
    if [ -f /sys/devices/soc0/soc_id ]; then
        soc_id=`cat /sys/devices/soc0/soc_id`
    fi

    #Apply settings for lagoon
    case "$soc_id" in
        "434" | "459" )

        # disable unfiltering
        echo 20000000 > /proc/sys/kernel/sched_task_unfilter_period

        # Setting b.L scheduler parameters
        # default sched up and down migrate values are 95 and 85
        echo 65 > /proc/sys/kernel/sched_downmigrate
        echo 71 > /proc/sys/kernel/sched_upmigrate

        # default sched up and down migrate values are 100 and 95
        echo 85 > /proc/sys/kernel/sched_group_downmigrate
        echo 100 > /proc/sys/kernel/sched_group_upmigrate
        echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks
        echo 0 > /proc/sys/kernel/sched_coloc_busy_hyst_ns
        echo 0 > /proc/sys/kernel/sched_coloc_busy_hysteresis_enable_cpus
        echo 0 > /proc/sys/kernel/sched_coloc_busy_hyst_max_ms

        # configure governor settings for little cluster
        echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 1248000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
        echo 576000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

        # configure governor settings for big cluster
        echo "schedutil" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
        echo 1248000 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_freq
        echo 652800 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq

        #colocation v3 settings
        echo 740000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/rtg_boost_freq
        echo 0 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/rtg_boost_freq
        echo 51 > /proc/sys/kernel/sched_min_task_util_for_boost

        # sched_load_boost as -6 is equivalent to target load as 85. It is per cpu tunable.
        echo -6 >  /sys/devices/system/cpu/cpu6/sched_load_boost
        echo -6 >  /sys/devices/system/cpu/cpu7/sched_load_boost
        echo 85 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_load

        # Enable conservative pl
        echo 1 > /proc/sys/kernel/sched_conservative_pl

	# Disable wsf for all targets beacause we are using efk.
	# wsf Range : 1..1000 So set to bare minimum value 1.
	echo 1 > /proc/sys/vm/watermark_scale_factor

        # cpuset parameters
        echo 0-5 > /dev/cpuset/background/cpus
        echo 0-5 > /dev/cpuset/system-background/cpus

        # Turn off scheduler boost at the end
        echo 0 > /proc/sys/kernel/sched_boost

        # Turn off sleep modes
        echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
      ;;
    esac
esac

# Post-setup services
case "$target" in
    "lito")
        setprop vendor.post_boot.parsed 1
    ;;
esac
