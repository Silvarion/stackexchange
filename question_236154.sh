#!/bin/ksh

rm output.txt > /dev/null 2>&1
column="initialized"
result=""
lineCounter=1
while read line
do
	print "LINE $lineCounter: $line"
	counter=1
	while [[ ${counter} -le 20 ]]
	do
		eval 'column=$(print ${line} | cut -d"|" -f$counter)'
		eval 'text=$(print ${line} | cut -d"|" -f$counter | grep \")'
		print "LINE ${lineCounter} COLUMN ${counter}: $column"
		if [[ "$column" = "$text" && -n ${column} ]]
		then
			if [[ "$result" = "" ]]
			then
				result="_2quotehere_${column}_2quotehere_"
			else
				result="${result}|_2quotehere_${column}_2quotehere_"
			fi
		else
			if [[ "$result" = "" ]]
			then
				result=${column}
			else
				result="${result}|${column}"
			fi
		fi
		echo $result | sed 's/_2quotehere_/"/g' > output.txt
		(( counter+=1 ))
	done
	(( lineCounter+=1 ))
done < input.txt
print "OUTPUT CONTENTS:"
cat output.txt

exit 0
