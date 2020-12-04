#List tunisian IPv4&IPv6 addresses with assigment dates

Color_Off='\e[0m'       # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
BBlack='\033[1;30m'       # Bold Black
BRed='\033[1;31m'         # Bold Red
BGreen='\033[1;32m'       # Bold Green
BYellow='\033[1;33m'      # Bold Yellow
BBlue='\033[1;34m'        # Bold Blue
BPurple='\033[1;35m'      # Bold Purple
BCyan='\033[1;36m'        # Bold Cyan
BWhite='\033[1;37m'       # Bold White

clear && cd /tmp
echo -e "\e[1;4;30;47m List tunisian IPv4 addresses with assigment dates \e[0m\n"
echo -e "\e[1;4;30;33m List tunisian IPv4 addresses with assigment dates $Color_Off\n"

cDate_ts=$(date -d `date +"%Y%m%d"` '+%s')
cYear=$(date +"%Y")
lastestFile=`curl -ls ftp://ftp.afrinic.net/pub/stats/afrinic/$cYear/|egrep "delegated-afrinic-$cYear"|egrep -v ".asc$|.md5$"|tail -1`
curl -s ftp://ftp.afrinic.net/pub/stats/afrinic/$cYear/$lastestFile > $lastestFile

echo -e "\n\e[1;4;30;47m IPv4 \e[0m\n"
for i in $(curl -s https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/tn.cidr|sort -V);do
 ii=$(echo $i|awk -F'/' '{print $1}')
 assigmentDate=$(cat /tmp/$lastestFile|egrep $ii|awk -F'|' '{print $6}')
 assigmentDate_ts=$(date -d `echo $assigmentDate` '+%s')
 diff_days=$(( ( cDate_ts - assigmentDate_ts )/(60*60*24) ))

 LIR=$(whois -h whois.afrinic.net $i |egrep netname:|awk -F":" '{print $2}'| sed -e 's/^[[:space:]]*//'| sed -e 's/[[:space:]]*$//' \
 |sed "s/ooredoo.*$/Ooredoo/gI;s/TUNISIANA.*$/Ooredoo/gI;s/^\s*TOPNET.*$/Topnet/gI;s/^\s*TN-ATI.*$/ATI/gI;s/^\s*Orange.*$/Orange/gI;s/Tunisie-Telecom.*$/TunisieTelecom/gI")

 if [ $diff_days -lt 180 ]; then
  echo -en $i"\t"$assigmentDate"\t"$LIR"\e[1;97;41m*\e[0m"
 else
  echo -en $i"\t"$assigmentDate"\t"$LIR
 fi
 echo
done|column -t

echo -e "\n\e[1;4;30;47m IPv6 \e[0m\n"
for i in $(curl -s https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv6/tn.cidr|sort -V);do
 ii=$(echo $i|awk -F'/' '{print $1}')
 assigmentDate=$(cat /tmp/$lastestFile|egrep $ii|awk -F'|' '{print $6}')
 assigmentDate_ts=$(date -d `echo $assigmentDate` '+%s')
 diff_days=$(( ( cDate_ts - assigmentDate_ts )/(60*60*24) ))

 LIR=$(whois -h whois.afrinic.net $i |egrep netname:|awk -F":" '{print $2}'| sed -e 's/^[[:space:]]*//'| sed -e 's/[[:space:]]*$//' \
 |sed "s/ooredoo.*$/Ooredoo/gI;s/TUNISIANA.*$/Ooredoo/gI;s/^\s*TOPNET.*$/Topnet/gI;s/^\s*TN-ATI.*$/ATI/gI;s/^\s*Orange.*$/Orange/gI;s/Tunisie-Telecom.*$/TunisieTelecom/gI")

 if [ $diff_days -lt 180 ]; then
  echo -en $i"\t"$assigmentDate"\t"$LIR"\e[1;97;41m*$Color_Off"
 else
  echo -en $i"\t"$assigmentDate"\t"$LIR
 fi
 echo
done|column -t
