#!/bin/bash

#####UserInfo
user_name=$( whoami )
user_hostname=$( uname -n )

#####Distro
distro=$( hostnamectl | grep Operating\ System | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
arch=$( hostnamectl | grep Architecture: | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
kernel=$( hostnamectl | grep Kernel | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
cpu=$( cat /proc/cpuinfo | grep model\ name | uniq | cut -d ":" -f2 | sed -e 's/^[ \t]*//' )

#####Memory in use (MemTotal-MemFree) - (Buffers+CachedMemory)

###Total RAM memory
ram_total=$( cat /proc/meminfo | grep MemTotal | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
number_total=${ram_total::len-3}
total_mb=$(( $number_total / 1024 )) 

### MemFree Memory
ram_free=$( cat /proc/meminfo | grep MemFree | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
number_free=${ram_free::len-3}

###Buffers Memory
ram_buffer=$( cat /proc/meminfo | grep Buffers | cut -d ':' -f2 | sed -e 's/^[ \t]*//') 
number_buffer=${ram_buffer::len-3}

###Cached Memory
ram_cached=$( cat /proc/meminfo | grep Cached: | head -n1 | cut -d ':' -f2 | sed -e 's/^[ \t]*//'  )
number_cached=${ram_cached::len-3}

###Used Memory
ram_used=$(( ( $number_total - $number_free ) - ( $number_buffer + $number_cached ) )) 
used_mb=$(( $ram_used / 1024 ))

### Panel 
echo -e " $user_name@$user_hostname\n"
echo -e " Λειτουργικό Σύστημα: $distro\n Αρχιτεκτονική: $arch\n Πυρήνας: $kernel\n Επεξεργαστής: $cpu\n Μνήμη RAM: $used_mb MB / $total_mb MB "


