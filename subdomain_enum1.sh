
echo " ${red}
          ___    ____   *
|\    |  |   |  |    |  |
| \   |  |   |  |____|  |
|  \  |  |   |  |____   |
|   \ |  |   |  |    |  |
|    \|  |___|  |____|	|
${reset}  "
echo "By Takester"
echo ""



mkdir ./$1

echo "*************************Subdomain Enumeration**************************************"
echo ""
echo ""
echo "---------------AssetFinder---------------------------"
assetfinder -subs-only $1 | tee $1/subs_assetfinder

echo "----------Crt.sh--------------------------------------"
curl -s https://crt.sh/?q=$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*.$1" | sort -u | awk 'NF' | tee $1/subs_crtsh

echo "-------------Findomain--------------------------------"
findomain -t $1 -o
cat $1.txt >> $1/subs_findomain
rm $1.txt

echo "------------Shodan Enumeration-----------------------------------"
~/shosubgo/shosubgo -d $1 -s TK5VkvBGBi8eA0l66n5l19q3aLKM0byg | tee $1/subs_shodan

echo "----------Subfinder-----------------------------------"
subfinder -d $1 -nW -o "$1/subs_subfind" -rL ~/dnsvalidator/resolvers.txt

echo "------------Sublister--------------------------------------------------------------------------"
python ~/Sublist3r/sublist3r.py -d $1 -o $1/subs_sublister

echo "-----------------------------Amaas(HAve patience)---------------------------------------------------------------------------------------"
amass enum -brute -w ~/amass_linux_amd64/examples/wordlists/jhaddix_all.txt -d $1 -config ~/amass_linux_amd64/config.ini -o $1/subs_amaas

echo "------------------Knockpy, github and google dorks do them manually--------------------------------"

cat $1/subs_assetfinder $1/subs_crtsh $1/subs_findomain $1/subs_shodan $1/subs_subfind $1/subs_sublister $1/subs_amaas | sed 's/*.//g' | sort -u | tee $1/subdomain
rm $1/subs_assetfinder $1/subs_crtsh $1/subs_findomain $1/subs_shodan $1/subs_subfind $1/subs_sublister $1/subs_amaas
echo "************************End of subdomain enumeration*********************************"
echo ""
echo ""

echo "---------------Checking for subdomain-takeover--------------------------------------------------------------------"
subjack -w $1/subdomain -t 100 -timeout 30 -ssl -c ~/subjack/fingerprints.json -v 3 | tee $1/takeover

./brut_res2.sh $1
./ip_ports3.sh $1
./probe_endpoints4.sh $1
