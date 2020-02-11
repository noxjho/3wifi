#!/bin/bash
 
IFACE='wlan0'
SCAN_ATTEMPTS=4
API_KEY='23ZRA8UBSLsdhbdJMp7IpbbsrDFDLuBC'
 
TMP_FILE='/tmp/scan_results.txt'
 
rm $TMP_FILE 2>/dev/null
 
for (( i=1; i<=$SCAN_ATTEMPTS; i=i+1 )); do
    echo "Scan #: $i"
    FOUND="$( sudo iw dev $IFACE scan | grep -E '^BSS' | grep -E -o '[0-9a-z:]{17}' )"
    echo "$FOUND" >> /tmp/scan_results.txt
    echo 'Found APs: ' `echo "$FOUND" | wc -l`
done
 
UNIQUE="$( cat $TMP_FILE | sort | uniq )"
echo '==================='
echo "Unique APs: "`echo "$UNIQUE" | wc -l`
 
echo "$UNIQUE" | while read -r line ; do
      echo "Trying $line...";
      echo -e "\033[0;32m`curl -s 'http://3wifi.stascorp.com/api/apiquery?key='$API_KEY'&bssid='$line`\e[0m" | grep -E -v ':\[\]';
      sleep 15;
done
