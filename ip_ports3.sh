
echo "*************************LiVe Ip's and PoRts***************************"
cat $1/final_subs | dnsprobe | tee $1/live_ip
cat $1/live_ip | awk '{print $2}' | sort -u >> $1/live_ip1
echo "-------------------------------------------------------------------------">> $1/ports_output
while read -r line;
do
	sudo masscan $line -p0-65535 --rate=10000 -Pn -sS | tee -a $1/ports_output
	echo "-------------------------------------------------------------------------">> $1/ports_output
done < $1/live_ip1
rm $1/live_ip1
