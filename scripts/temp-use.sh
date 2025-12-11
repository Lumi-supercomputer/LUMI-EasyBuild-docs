selecttc buildtools-24.03.eb result ; echo $result

for file in $(find . -name "*.eb") ; do selecttc $file result ; echo "$file: $result"; done


