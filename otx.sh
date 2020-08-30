#!/bin/bash


otx()
{
	gron "https://otx.alienvault.com/otxapi/indicator/hostname/url_list/$1?limit=100&page=1" | grep "\burl\b" | gron --ungron | jq

}



while read -r line;
do
	 otx $line
done < ~/bugs/
