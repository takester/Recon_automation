
echo "*************************LiVe Ip's and PoRts***************************"
massdns -r ~/dnsvalidator/resolvers.txt -t A -o S -w $1/massdns_ip $1/final_subs
cat $1/massdns_ip | cut -d" " -f3 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"| sort -u >> $1/live_ip

python3 ~/scripts/ip_clean.py $1/live_ip $1/clean_ip

sudo masscan -iL $1/clean_ip -p0-65535 --rate=10000 -Pn -sS -n -oL $1/ports_output
rm $1/live_ip

sed -i -e '/#/d' -e '/^$/d' $1/ports_output
cat $1/ports_output | sed -e '/#/d' -e '/^$/d' | cut -d" " -f3,4 | awk '{print($2","$1)}' | sort -V >> $1/tmp_nmap

python3 ~/scripts/nmap_input_file.py $1/tmp_nmap $1/nmap_input

mkdir $1/nmap
while read -r line;
do
	 ip=`echo $line | cut -d" " -f1`
	 port=`echo $line | cut -d" " -f2`
	nmap -sC -sV -Pn -n -v $ip -p $port -oA $1/nmap/$ip
done < $1/nmap_input

#rm $1/tmp_nmap $1/nmap_input
