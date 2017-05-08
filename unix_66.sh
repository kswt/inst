#!/bin/bash
read -p "Please, enter the number: " n

users_list=$(users | tr ' ' '\n' | sort | uniq)
for un in $users_list; do
	let average_process+=$(ps -u "$un" | wc -l)
	let nusers++
done
let average_process/=nusers

for un in $users_list; do
    usrn=$(ps -u "$un" | wc -l)
    echo "Average number of processes per user is $average_process" | write "$un"
    if [ $(expr $average_process - $usrn) -gt $n ];
    then 
        echo "You have $usrn process(es), it's greater than average + $n." | write "$un"
    fi
done
