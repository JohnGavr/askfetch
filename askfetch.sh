#!/bin/bash
export TEXTDOMAIN=askfetch
export TEXTDOMAINDIR=$PWD/locale
. gettext.sh

# THis function is taken from screenfectch github repo
# DE Detection - Begin
detectde () {
	DE="Not Present"
	if [[ "${distro}" == "Mac OS X" ]]; then
		if ps -U "${USER}" | grep -q -i 'finder'; then
			DE="Aqua"
		fi
	elif [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
		# https://msdn.microsoft.com/en-us/library/ms724832%28VS.85%29.aspx
		if wmic os get version | grep -q '^\(6\.[01]\)'; then
			DE="Aero"
		elif wmic os get version | grep -q '^\(6\.[23]\|10\)'; then
			DE="Modern UI/Metro"
		else
			DE="Luna"
		fi
	elif [[ -n ${DISPLAY} ]]; then
		if type -p xprop >/dev/null 2>&1;then
			xprop_root="$(xprop -root 2>/dev/null)"
			if [[ -n ${xprop_root} ]]; then
				DE=$(echo "${xprop_root}" | awk 'BEGIN {
					de = "Not Present"
				}
				{
					if ($1 ~ /^_DT_SAVE_MODE/) {
						de = $NF
						gsub(/\"/,"",de)
						de = toupper(de)
						exit
					}
					else if ($1 ~/^KDE_SESSION_VERSION/) {
						de = "KDE"$NF
						exit
					}
					else if ($1 ~ /^_MUFFIN/) {
						de = "Cinnamon"
						exit
					}
					else if ($1 ~ /^TDE_FULL_SESSION/) {
						de = "Trinity"
						exit
					}
					else if ($0 ~ /"xfce4"/) {
						de = "Xfce4"
						exit
					}
					else if ($0 ~ /"xfce5"/) {
						de = "Xfce5"
						exit
					}
				} END {
					print de
				}')
			fi
		fi

		if [[ ${DE} == "Not Present" ]]; then
			# Let's use xdg-open code for GNOME/Enlightment/KDE/LXDE/MATE/Xfce detection
			# http://bazaar.launchpad.net/~vcs-imports/xdg-utils/master/view/head:/scripts/xdg-utils-common.in#L251
			if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
				case "${XDG_CURRENT_DESKTOP,,}" in
					'enlightenment')
						DE="Enlightenment"
						;;
					'gnome')
						DE="GNOME"
						;;
					'kde')
						DE="KDE"
						;;
					'lumina')
						DE="Lumina"
						;;
					'lxde')
						DE="LXDE"
						;;
					'mate')
						DE="MATE"
						;;
					'xfce')
						DE="Xfce"
						;;
					'x-cinnamon')
						DE="Cinnamon"
						;;
					'unity')
						DE="Unity"
						;;
					'lxqt')
						DE="LXQt"
						;;
				esac
			fi

			if [ -n "$DE" ]; then
				# classic fallbacks
				if [ -n "$KDE_FULL_SESSION" ]; then
					DE="KDE"
				elif [ -n "$TDE_FULL_SESSION" ]; then
					DE="Trinity"
				elif [ -n "$GNOME_DESKTOP_SESSION_ID" ]; then
					DE="GNOME"
				elif [ -n "$MATE_DESKTOP_SESSION_ID" ]; then
					DE="MATE"
				elif dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus \
					org.freedesktop.DBus.GetNameOwner string:org.gnome.SessionManager >/dev/null 2>&1 ; then
					DE="GNOME"
				elif xprop -root _DT_SAVE_MODE 2> /dev/null | grep -q -i ' = \"xfce4\"$'; then
					DE="Xfce"
				elif xprop -root 2> /dev/null | grep -q -i '^xfce_desktop_window'; then
					DE="Xfce"
				elif echo "$DESKTOP" | grep -q -i '^Enlightenment'; then
					DE="Enlightenment"
				fi
			fi

			if [ -n "$DE" ]; then
				# fallback to checking $DESKTOP_SESSION
				case "${DESKTOP_SESSION,,}" in
					'gnome'*)
						DE="GNOME"
						;;
					'deepin')
						DE="Deepin"
						;;
					'lumina')
						DE="Lumina"
						;;
					'lxde'|'lubuntu')
						DE="LXDE"
						;;
					'mate')
						DE="MATE"
						;;
					'xfce'*)
						DE="Xfce"
						;;
					'budgie-desktop')
						DE="Budgie"
						;;
					'cinnamon')
						DE="Cinnamon"
						;;
					'trinity')
						DE="Trinity"
						;;
				esac
			fi

			if [ -n "$DE" ]; then
				# fallback to checking $GDMSESSION
				case "${GDMSESSION,,}" in
					'lumina'*)
						DE="Lumina"
						;;
					'mate')
						DE="MATE"
						;;
				esac
			fi

			if [[ ${DE} == "GNOME" ]]; then
				if type -p xprop >/dev/null 2>&1; then
					if xprop -name "unity-launcher" >/dev/null 2>&1; then
						DE="Unity"
					elif xprop -name "launcher" >/dev/null 2>&1 &&
						xprop -name "panel" >/dev/null 2>&1; then
						DE="Unity"
					fi
				fi
			fi

			if [[ ${DE} == "KDE" ]]; then
				if [[ -n ${KDE_SESSION_VERSION} ]]; then
					if [[ ${KDE_SESSION_VERSION} == '5' ]]; then
						DE="KDE5"
					elif [[ ${KDE_SESSION_VERSION} == '4' ]]; then
						DE="KDE4"
					fi
				elif [[ ${KDE_FULL_SESSION} == 'true' ]]; then
					DE="KDE"
					DEver_data=$(kded --version 2>/dev/null)
					DEver=$(grep -si '^KDE:' <<< "$DEver_data" | awk '{print $2}')
				fi
			fi
		fi

		if [[ ${DE} != "Not Present" ]]; then
			if [[ ${DE} == "Cinnamon" ]]; then
				if type -p >/dev/null 2>&1; then
					DEver=$(cinnamon --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "GNOME" ]]; then
				if type -p gnome-control-center>/dev/null 2>&1; then
					DEver=$(gnome-control-center --version 2> /dev/null)
					DE="${DE} ${DEver//* }"
				elif type -p gnome-session-properties >/dev/null 2>&1; then
					DEver=$(gnome-session-properties --version 2> /dev/null)
					DE="${DE} ${DEver//* }"
				elif type -p gnome-session >/dev/null 2>&1; then
					DEver=$(gnome-session --version 2> /dev/null)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "KDE4" || ${DE} == "KDE5" ]]; then
				if type -p kded"${DE#KDE}" >/dev/null 2>&1; then
					DEver=$(kded"${DE#KDE}" --version)
					if [[ $(( $(echo "$DEver" | wc -w) )) -eq 2 ]] && [[ "$(echo "$DEver" | cut -d ' ' -f1)" == "kded${DE#KDE}" ]]; then
						DEver=$(echo "$DEver" | cut -d ' ' -f2)
						DE="KDE ${DEver}"
					else
						for l in "${DEver// /_}"; do
							if [[ ${l//:*} == "KDE_Development_Platform" ]]; then
								DEver=${l//*:_}
								DE="KDE ${DEver//_*}"
							fi
						done
					fi
					if pgrep -U ${UID} plasmashell >/dev/null 2>&1; then
						DEver=$(plasmashell --version | cut -d ' ' -f2)
						DE="$DE / Plasma $DEver"
					fi
				fi
			elif [[ ${DE} == "Lumina" ]]; then
				if type -p Lumina-DE.real >/dev/null 2>&1; then
					lumina="$(type -p Lumina-DE.real)"
				elif type -p Lumina-DE >/dev/null 2>&1; then
					lumina="$(type -p Lumina-DE)"
				fi
				if [ -n "$lumina" ]; then
					if grep -q '--version' "$lumina"; then
						DEver=$("$lumina" --version 2>&1 | tr -d \")
						DE="${DE} ${DEver}"
					fi
				fi
			elif [[ ${DE} == "MATE" ]]; then
				if type -p mate-session >/dev/null 2>&1; then
					DEver=$(mate-session --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "Unity" ]]; then
				if type -p unity >/dev/null 2>&1; then
					DEver=$(unity --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "Deepin" ]]; then
				if [[ -f /etc/deepin-version ]]; then
					DEver="$(awk -F '=' '/Version/ {print $2}' /etc/deepin-version)"
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "Trinity" ]]; then
				if type -p tde-config >/dev/null 2>&1; then
					DEver="$(tde-config --version | awk -F ' ' '/TDE:/ {print $2}')"
					DE="${DE} ${DEver//* }"
				fi
			fi
		fi

		if [[ "${DE}" == "Not Present" ]]; then
			if pgrep -U ${UID} lxsession >/dev/null 2>&1; then
				DE="LXDE"
				if type -p lxpanel >/dev/null 2>&1; then
					DEver=$(lxpanel -v)
					DE="${DE} $DEver"
				fi
			elif pgrep -U ${UID} lxqt-session >/dev/null 2>&1; then
				DE="LXQt"
			elif pgrep -U ${UID} razor-session >/dev/null 2>&1; then
				DE="RazorQt"
			elif pgrep -U ${UID} dtsession >/dev/null 2>&1; then
				DE="CDE"
			fi
		fi
	fi
echo -n "${DE}"
}

### DE Detection - End

# Print usage
usage() {
  echo -n "askfetch.sh [OPTION]...

Askfetch.sh system information tool.

 Options:
  -l,	Script locale (e.g. el,en). Default is en.
  -d,	Distribution logo. Default is current installed distribution.
  -h,	Display this help and exit
"
}


# Flag and Argument parsing
# check flags

distro_id=$(grep "^ID=" < /etc/os-release | cut -d '=' -f2 )

while getopts ":l:d:h" option
do
	case "${option}" in
		l ) 
			
			if [[ ${OPTARG} == "el" ]]; then
				export LANGUAGE=el
			elif [[ ${OPTARG} == "en" ]]; then
				export LANGUAGE=en
			else 
				printf "%s " $(gettext "Error: Unrecognized locale"); printf "\n"
			fi
			;; #get locale option
		d )
			distro_id=${OPTARG}
			;;
		h )
			usage
			exit
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
cpu=$( grep model\ name < /proc/cpuinfo | uniq | cut -d ":" -f2 | sed -e 's/^[ \t]*//' -e 's/\ \ */\ /g' )

#####Memory in use (MemTotal-MemFree) - (Buffers+CachedMemory)

###Total RAM memory
ram_total=$(grep MemTotal < /proc/meminfo | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
number_total=${ram_total::len-3}
total_mb=$(( number_total / 1024 )) 

### MemFree Memory
ram_free=$( grep MemFree < /proc/meminfo | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
number_free=${ram_free::len-3}

###Buffers Memory
ram_buffer=$( grep Buffers < /proc/meminfo | cut -d ':' -f2 | sed -e 's/^[ \t]*//') 
number_buffer=${ram_buffer::len-3}

##Cached Memory
ram_cached=$(grep Cached: < /proc/meminfo | head -n1 | cut -d ':' -f2 | sed -e 's/^[ \t]*//'  )
number_cached=${ram_cached::len-3}

###Used Memory
ram_used=$(( ( number_total - number_free ) - ( number_buffer + number_cached ) )) 
used_mb=$(( ram_used / 1024 ))


#Build system info with i18n (eval_gettext because evaluated expressions inside strings are used)
operating_system=$(eval_gettext "Operating system: \$distro")
architecture=$(eval_gettext "Architecture: \$arch")
kernel_ver=$(eval_gettext "Kernel: \$kernel")
cpu_model=$(eval_gettext "CPU: \$cpu")

ram_info_value="$used_mb MB / $total_mb MB"
ram_info=$(eval_gettext "RAM: \$ram_info_value")

#Desktop Environment
de_string=$(detectde)
de=$(eval_gettext "DE: \$de_string")

#Installed for
installed_for_string=$(source installed_for/installed_for.sh)
installed_for=$(eval_gettext "Installed for: \$installed_for_string")


## Add distribution logo

### Define tabs for better printing
tabs 1

c0=$'\033[0m' # Reset Text

#Get proper logo for distro
logo_file_color=$(grep "label_color: " < "$PWD"/logos/$distro_id.txt| cut -d ':' -f2 | tr -d '\n' | tr -d '\r' | sed -e 's/^[[:space:]]*//') #remove trailing and leading chars

c1=$logo_file_color
systeminfo="\n${c1}${user_name}@${user_hostname}$c0\n$operating_system\n$architecture\n$kernel_ver\n$cpu_model\n$ram_info\n$de\n$installed_for"

logo_color=$(printf "%s" "$c1") # generate escape character for color https://unix.stackexchange.com/a/45954 
logo=$(awk 'BEGIN{ found=0} {if (found) print } /logo\:/{found=1} ' < "$PWD"/logos/$distro_id.txt)
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

logo_with_correct_width=$(awk -v max_length=$max_length -v c0=$c0 -v b="$b" 'BEGIN {split(b,b_awk,",") }{printf("%s%"max_length-b_awk[NR]"s"c0"\n",substr($0,1,length($0)),"");}' <(printf "%s" "$logo"))
# print in two columns side by side
pr -Tmi1 -J -o1 -S"  "  <(echo -e "$logo_with_correct_width") <(printf %b "$systeminfo")

