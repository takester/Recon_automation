


echo "-------------------Probing the URLS----------------------------------"
cat $1/final_subs | httpx | tee $1/httpx_sub
cat $1/final_subs | httprobe | tee $1/httprobe_sub
cat $1/httpx_sub $1/httprobe_sub | sort -u >> $1/alive_subs
rm $1/httprobe_sub $1/httpx_sub
echo ""
echo ""




echo "-------------Get_All_Urls-----------------------------------------"
cat $1/final_subs | hakrawler --depth 3 --plain | tee $1/data_hakrawler
cat $1/final_subs | gau | tee $1/data_gau
cat $1/final_subs | waybackurls | tee $1/data_wayback
cat $1/data_hakrawler $1/data_gau $1/data_wayback | sort -u >> $1/waybackdata
rm $1/data_hakrawler $1/data_gau $1/data_wayback
echo ""
echo ""




echo "***************Javascript enumeration***********************************"
echo ""
echo ""
echo "--------------------------Javascript Endpoints----------------------------------------------"
cat $1/waybackdata | grep -iE "\.js$" | sort -u >> $1/java_links
cat $1/alive_subs | subjs >> $1/java_links
cat $1/alive_subs | hakrawler --plain -depth 3 -js | tee $1/java_links
cat $1/java_links | sort -u | httpx -silent -follow-redirects -status-code | grep 200 | awk '{print $1}' | sort -u > $1/live_jslinks

parallel -j 12 "python3 ~/LinkFinder/linkfinder.py -i {} -o cli 2> /dev/null" :::: $1/live_jslinks | tee $1/java_endpoints
rm $1/java_links
echo ""
echo ""


echo "-------------Javascript Secrets---------------------------------------------------------------"
parallel -j 12 "python3 ~/SecretFinder/SecretFinder.py -i {} -o cli 2> /dev/null" :::: $1/alive_subs >> $1/js_secrets1
parallel -j 12 "python3 ~/SecretFinder/SecretFinder.py -i {} -o cli 2> /dev/null" :::: $1/live_jslinks >> $1/js_secrets1
cat $1/js_secrets1 | sort -u | tee $1/js_secrets
rm $1/js_secrets1
echo ""
echo ""

echo "-----------------------------JS_Wordlist--------------------------------------------------------"
cat $1/live_jslinks | python3 ~/scripts/getjswords.py >> $1/js_wordlist1
cat $1/js_wordlist1 | sort -u | tee $1/js_wordlist
rm $1/js_wordlist1
echo ""
echo ""

echo "--------------------JS_file_download-------------------------------------------------------------"
count=1
mkdir $1/jsfiles
while read -r line;
do
	python3 ~/scripts/jsbeautify.py $line $1/jsfiles/$count.js
	((count=count+1))
done < $1/live_jslinks
echo ""
echo ""
rm $1/live_jslinks


