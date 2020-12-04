#List tunisian IPv4 addresses with assigment dates

clear && cd /tmp
cDate_ts=$(date -d `date +"%Y%m%d"` '+%s')

cYear=$(date +"%Y")
lastestFile=`curl -ls ftp://ftp.afrinic.net/pub/stats/afrinic/$cYear/|egrep "delegated-afrinic-$cYear"|egrep -v ".asc$|.md5$"|tail -1`

curl -s ftp://ftp.afrinic.net/pub/stats/afrinic/$cYear/$lastestFile > $lastestFile

for i in $(curl -s https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/tn.cidr|sort -V);do
 echo -en $i"\t"
 ii=$(echo $i|awk -F'/' '{print $1}')
 
 assigmentDate=$(cat /tmp/$lastestFile|egrep $ii|awk -F'|' '{print $6}')
 assigmentDate_ts=$(date -d `echo $assigmentDate` '+%s')
 diff_days=$(( ( cDate_ts - assigmentDate_ts )/(60*60*24) ))

 if [ $diff_days -lt 60 ]; then
  echo -en "\e[31m"$assigmentDate"\e[0m""\t"
 else
  echo -en $assigmentDate"\t"
 fi
 whois -h whois.afrinic.net $i |egrep netname:|awk -F":" '{print $2}'| sed -e 's/^[[:space:]]*//'| sed -e 's/[[:space:]]*$//'
done|column -t








#clear && cd /tmp
#cYear=$(date +"%Y")
#lastestFile=`curl -ls ftp://ftp.afrinic.net/pub/stats/afrinic/$cYear/|egrep "delegated-afrinic-$cYear"|egrep -v ".asc$|.md5$"|tail -1`

#curl -s ftp://ftp.afrinic.net/pub/stats/afrinic/$cYear/$lastestFile > $lastestFile

#for i in $(curl -s https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/tn.cidr|sort -V);do
# echo -en $i"\t"
# ii=$(echo $i|awk -F'/' '{print $1}')
# echo -en $(cat /tmp/$lastestFile|egrep $ii|awk -F'|' '{print $6}')"\t"
# whois -h whois.afrinic.net $i |egrep netname:|awk -F":" '{print $2}'| sed -e 's/^[[:space:]]*//'| sed -e 's/[[:space:]]*$//'
#done|column -t
