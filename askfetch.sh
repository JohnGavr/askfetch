#!/bin/bash
export TEXTDOMAIN=askfetch
export TEXTDOMAINDIR=$PWD/locale
. gettext.sh

# Flag and Argument parsing
# check flags

distro_id=$( cat /etc/os-release | grep "ID=" | cut -d '=' -f2 )

while getopts ":l:d:" option
do
	case "${option}" in
		l ) 
			
			if [[ ${OPTARG} == "el" ]]; then
				export LANGUAGE=el
			elif [[ ${OPTARG} == "en" ]]; then
				export LANGUAGE=en
			else 
				printf $(gettext "Error: Unrecognized locale") ; printf "\n"
			fi
			;; #get locale option
		d )
			distro_id=${OPTARG}
			;;
	esac

done

#####UserInfo
user_name=$(whoami)
user_hostname=$( uname -n )

#####Distro
distro=$( hostnamectl | grep Operating\ System | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )


# if thgere isn't any available stick to the default tux
if [ ! -e "$PWD"/logos/"$distro_id".txt ]; then
    distro_id="default"
fi

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

##Cached Memory
ram_cached=$( cat /proc/meminfo | grep Cached: | head -n1 | cut -d ':' -f2 | sed -e 's/^[ \t]*//'  )
number_cached=${ram_cached::len-3}

###Used Memory
ram_used=$(( ( $number_total - $number_free ) - ( $number_buffer + $number_cached ) )) 
used_mb=$(( $ram_used / 1024 ))


#Build system info with i18n (eval_gettext because evaluated expressions inside strings are used)
operating_system=$(eval_gettext "Operating system: \$distro")
architecture=$(eval_gettext "Architecture: \$arch")
kernel_ver=$(eval_gettext "Kernel: \$kernel")
cpu_model=$(eval_gettext "CPU: \$cpu")

ram_info_value="$used_mb MB / $total_mb MB"
ram_info=$(eval_gettext "RAM: \$ram_info_value")

## Add distribution logo

### Define tabs for better printing
tabs 1



c0=$'\033[0m' # Reset Text

#Get proper logo for distro
logo_file_color=$(cat $PWD/logos/$distro_id.txt | grep "label_color: " | cut -d ':' -f2 | tr -d '\n' | tr -d '\r' | sed -e 's/^[[:space:]]*//') #remove trailing and leading chars

c1=$logo_file_color
systeminfo="\n${c1}${user_name}@${user_hostname}$c0\n$operating_system\n$architecture\n$kernel_ver\n$cpu_model\n$ram_info"

logo_color=$(printf "$c1") # generate escape character for color https://unix.stackexchange.com/a/45954 
logo=$(cat $PWD/logos/$distro_id.txt | awk 'BEGIN{ found=0} {if (found) print } /logo\:/{found=1} ')
#before merging check input file lines and compare to system info
extra_lines_for_logo=$((6- $(wc -l <(printf "%b" "$logo") | awk '{ print $1 }'))) #19 is the number of lines of systeminfo

for (( i = 0; i < $extra_lines_for_logo; i++ )); do
	logo="${logo}$(printf "\n%b" " ")"
done

#before printing we should align all lines to the longest length 
max_length=$(($(awk '{print length}'  <(sed -r 's/\\e\[[0-9][0-9]m//g' <(printf %s "$logo")) |sort -nr|head -1)))  
max_length_with_color_codes=$(($(awk '{print length}'   <(printf %s "$logo") |sort -nr|head -1)))  

lengths_with_color_code=($(awk '{print length}'   <(printf %s "$logo") ))
lengths_without_color_code=( $(awk '{print length}'  <(sed -r 's/\\e\[[0-9]{1,2}m//g' <(printf %s "$logo"))) )

b=$( printf "%s," "${lengths_without_color_code[@]}" )

logo_with_correct_width=$(awk -v max_length=$max_length -v c0=$c0 -v b="$b" 'BEGIN {split(b,b_awk,",") }{printf("%s%"max_length-b_awk[NR]"s"c0"\n",substr($0,1,length($0)),"");}' <(printf "%b" "$logo"))
# print in two columns side by side
pr -Tmi1 -J -o1 -S"  "  <(echo "$logo_with_correct_width") <(printf %b "$systeminfo")
