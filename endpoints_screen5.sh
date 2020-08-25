#$1/alive_subs
#$1/final_subs
#$1/waybackdata



echo "-----------Shodan Host search----------------------------------------------------------------"
cat $1/live_ip | awk '{print $2}' >> $1/ips
echo "-------------------------------------------------------------------------" >> $1/shodan_host_search
while read -r line;
do
	shodan host $line >> $1/shodan_host_search
	echo "-------------------------------------------------------------------------" >> $1/shodan_host_search
done < $1/ips
rm $1/ips
echo ""
echo ""

echo "-------------------Aquatone Screen Shots------------------------------------------------------"
cat $1/alive_subs | aquatone -out $1/screen
echo ""
echo ""

echo "-------------------For kxss for xss----------------------------------------------------------"
cat $1/waybackdata | grep '=' | kxss | grep 'is reflected and allows' | awk '{print $9}'| sort -u >> $1/kxss_output

echo ""
echo ""


echo "----------------------------------Dalfox for Xss----------------------------------------------------"
cat $1/waybackdata | grep "=" | dalfox pipe -b Takester.xss.ht -o $1/dalfox_output
echo ""
echo ""

echo "--------------------GItHub endpoints----------------------------------------------------------" 
mkdir $1/github_enpt
while read -r line;
do
   python3 ~/github-search/github-endpoints.py -d $line -s -r | tee $1/github_enpt/$line.txt
done < $1/final_subs
echo ""
echo ""

echo "--------------------GItHub secrets----------------------------------------------------------"
mkdir $1/github_secret
while read -r line;
do
   python3 ~/github-search/github-secrets.py -s $line | tee $1/github_secret/$line.txt
done < $1/final_subs
echo ""
echo ""

echo "--------------------HTTP-Smuggler----------------------------------------------------------------"
cat $1/alive_subs | python3 ~/smuggler/smuggler.py | tee $1/http_smuggler
echo ""
echo ""

