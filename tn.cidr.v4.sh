#List tunisian IPv4&IPv6 addresses with assigment dates

Color_Off='\e[0m'       # Text Reset
cDate_ts=$(date -d `date +"%Y%m%d"` '+%s')
cYear=$(date +"%Y")

clear && cd /tmp
echo -e "\e[1;4;30;47m List tunisian IPv4 addresses with assigment dates $Color_Off\n"

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
  echo -en $i"\t"$assigmentDate"\t"$LIR"\e[1;97;41m*$Color_Off"
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
