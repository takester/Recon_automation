echo "************************Subdmain Bruteforce and resolver ****************************************"

#hi this is dhiraj
shuffledns -d $1 -list $1/subdomain -r ~/dnsvalidator/resolvers.txt -o $1/resolve > /dev/null 2>&1
cat $1/resolve | sort -u >> $1/resolve1
cat $1/resolve1 > $1/resolve
rm $1/resolve1

shuffledns -d $1 -w ~/bugs/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -r ~/dnsvalidator/resolvers.txt -o $1/shuffledns_resolve
cat $1/shuffledns_resolve | sort -u >> $1/shuffledns_resolve1
cat $1/shuffledns_resolve1 > $1/shuffledns_resolve
rm $1/shuffledns_resolve1

cat $1/resolve $1/shuffledns_resolve | sort -u >> $1/subdomain1

#echo "------------------------------------Altdns resolving(Will take time)---------------------------------------------------------------"
#altdns -i $1/subdomain -o $1/data_output -w ~/altdns/words.txt -r -s $1/results_output.txt
#cat $1/results_output.txt| awk -F ":" '{print $1}' | tee $1/altdns_resolve
#rm $1/results_output.txt $1/data_output

cat $1/subdomain1 | sort -u | tee $1/resolve_subs

rm $1/subdomain1 $1/resolve $1/shuffledns_resolve
echo "******************End bruteforce and resolve**************************************************************************************"

echo "---------------Checking for subdomain-takeover--------------------------------------------------------------------"
subjack -w $1/resolve_subs -t 100 -timeout 30 -ssl -c ~/subjack/fingerprints.json -v 3 | tee -a $1/takeover

mv $1/resolve_subs $1/final_subs
