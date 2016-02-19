#! /bin/bash -x

identify -list format | grep -E -v " (CLIP|CUR|HTM|HTML|ICO|ICON|JPT|MASK|MSL|MVG|RGF|TEXT|THUMBNAIL|TXT)\*" | tee identify_format_list.txt
grep ' [*,r,w,+,-][*,r,w,+,-][*,r,w,+,-]   ' identify_format_list.txt | tee identify_format_list_clean.txt
awk '{print $1}' identify_format_list_clean.txt | tee identify_format_list_Format.txt
awk '{print $2}' identify_format_list_clean.txt | tee identify_format_list_Module.txt
awk '{print $3}' identify_format_list_clean.txt | tee identify_format_list_Mode.txt
cut -c 28- identify_format_list_clean.txt | sed -e 's/^\ //g' | sed -e 's/^\ //g' | sed -e 's/^\ //g' | tee identify_format_list_Description.txt
cat identify_format_list_Format.txt | sed -e 's/\*$//g' | tr '[:upper:]' '[:lower:]' | tee identify_format_list_Format_lc.txt
echo -e "# Surge-Logo\nRaleigh Surge Logo\n\n| Format | Description | No Outline | White Outline | Black Outline |\n| -----: | :---------- | :---: | :---: | :---: |" > ../../README.md
paste identify_format_list_Format_lc.txt identify_format_list_Description.txt identify_format_list_Format_lc.txt identify_format_list_Format_lc.txt identify_format_list_Format_lc.txt identify_format_list_Format_lc.txt identify_format_list_Format_lc.txt identify_format_list_Format_lc.txt | sed -e 's/^/| /g' | sed -e 's/$/) |/g' >> ../../README.md
sed -i -e 's/\t/ | /' ../../README.md
sed -i -e 's/\t/ | [No Outline](https:\/\/raw\.githubusercontent\.com\/bdperkin\/Surge-Logo\/master\/formats\//' ../../README.md
sed -i -e 's/\t/\/Surge-Logo-No-Outline\./' ../../README.md
sed -i -e 's/\t/) | [White Outline](https:\/\/raw\.githubusercontent\.com\/bdperkin\/Surge-Logo\/master\/formats\//' ../../README.md
sed -i -e 's/\t/\/Surge-Logo-White-Outline\./' ../../README.md
sed -i -e 's/\t/) | [Black Outline](https:\/\/raw\.githubusercontent\.com\/bdperkin\/Surge-Logo\/master\/formats\//' ../../README.md
sed -i -e 's/\t/\/Surge-Logo-Black-Outline\./' ../../README.md

