#!/bin/bash
function whether_changed(){
    local file_path=${1}
    local check_time=${2}

    # return commond exe value, format:
    # variable=`commands`
    # variable=$(commands)
    file_old_stat=`stat ${file_path}|grep Modify`
    sleep ${check_time}
    file_new_stat=$(stat ${file_path}|grep Modify)
    if [[ $(echo ${file_old_stat}) != $(echo ${file_new_stat}) ]];
    then
        if [[ $(git diff ${file_path}) != $echo ]];
        then
            echo "file ${file_path} changed! execute git add"
            $(git add ${file_path})
        else
            echo "file ${file_path} changed! but not tracked by git"
        fi
    fi
}

function read_dir(){
for file in $(ls $1)
do
 if [ -d $1"/"$file ]
 then
 # // if sub dir, recursive call read_dir function
 read_dir $1"/"$file
 else
 # echo value > return value 
 echo $1"/"$file
 fi
done
}

echo "Big brother is watching you"
echo "Files under $1 will be checked every ${2} second"
while [[ true ]]; do
    # call read_dir function to list all files
    for file in $(read_dir $1)
    do
        # cmd end with '&', run background
        whether_changed $file $2 &
    done
    wait
done
