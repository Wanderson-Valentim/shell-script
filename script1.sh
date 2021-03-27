#!/bin/bash
echo "Type the owner:"
read owner
echo "Type the repository:"
read repo
echo "Type the language:"
read language

curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$owner/$repo/pulls?state=closed&page=1&per_page=100" > $repo.txt

curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$owner/$repo/pulls?state=closed&page=2&per_page=100" >> $repo.txt

sed -n -i '/"title"/,/"id"/p' $repo.txt

sed -n -i '/"title"/,/"creator"/p' $repo.txt

sed -i '/"title"/d; /"user"/d; /"id"/d; /"description"/d; /"creator"/d;s/\ \+//g; s/login\+//g; s/"\+//g; s/:\+//g' $repo.txt

cat $repo.txt | sort | uniq -c | sort -n -r | cut -c9- > logins.txt
cat $repo.txt | sort | uniq -c | sort -n -r | cut -c5-7 > repetitions.txt

name=`echo "$language""_""$repo"`
paste -d " " logins.txt repetitions.txt > $name.csv

rm $repo.txt
rm logins.txt
rm repetitions.txt