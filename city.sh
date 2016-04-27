#!/bin/sh
####################################  zh_cn  #######################################
awk 'BEGIN{FS="|";OFS=",";} $1=="zh_CN"{print $2,$3}' regions.txt |  awk 'BEGIN{FS="_";OFS=","} {print $1,$2,$3,$4}' | awk 'BEGIN{FS=",";OFS=","} $4!=""{print $1,$2,$3,$4}'  > regions_zh.csv  
awk 'BEGIN{FS="|";OFS=",";} $1=="zh_CN"{print $2,$3}' regions.txt |  awk 'BEGIN{FS="_";OFS=","} {print $1,$2,$3,$4}' | awk 'BEGIN{FS=",";OFS=","} $4==""&&$3!=""{print $1,$2,$3}'  > regions_zh_state.csv  
awk 'BEGIN{FS="|";OFS=",";} $1=="zh_CN"{print $2,$3}' regions.txt |  awk 'BEGIN{FS="_";OFS=","} {print $1,$2,$3,$4}' | awk 'BEGIN{FS=",";OFS=","} $3==""{print $1,$2}'  > regions_zh_country.csv  

conn="mysql -h192.168.15.81 -uroot -proot"

## 先插入有城市
cat /dev/null >tbl_city.sql
cnt=1
while read line
do
    IFS="," && arr=($line) && unset IFS
    if [ -z "`cat tbl_city.sql`" ]; then
        echo ";"
        echo -n ";insert into test.tbl_city(country_code,\`state\`, city, city_zh) values(\"${arr[0]}\", \"${arr[1]}\", \"${arr[2]}\", \"${arr[3]}\")" >> tbl_city.sql
        cnt=$((cnt+1))
    elif [ $cnt -gt 100 ]; then
        echo ";"
        echo -n ";insert into test.tbl_city(country_code,\`state\`, city, city_zh) values(\"${arr[0]}\", \"${arr[1]}\", \"${arr[2]}\", \"${arr[3]}\")" >> tbl_city.sql
        cnt=1
    else
        echo -n ",(\"${arr[0]}\", \"${arr[1]}\", \"${arr[2]}\", \"${arr[3]}\")" >> tbl_city.sql
        cnt=$((cnt+1))
    fi
done < regions_zh.csv
echo ";">> tbl_city.sql

## 插入地区
cnt=0
while read line
do
    IFS="," && arr=($line) && unset IFS
    if [ $cnt -eq 0 ]; then
        echo ";"
        echo -n ";insert into test.tbl_city(country_code,\`state\`, state_zh) values(\"${arr[0]}\", \"${arr[1]}\", \"${arr[2]}\")" >> tbl_city.sql
        cnt=2
    elif [ $cnt -gt 100 ]; then
        echo ";"
        echo -n ";insert into test.tbl_city(country_code,\`state\`, state_zh) values(\"${arr[0]}\", \"${arr[1]}\", \"${arr[2]}\")" >> tbl_city.sql
        cnt=1
    else
        echo -n ",(\"${arr[0]}\", \"${arr[1]}\", \"${arr[2]}\")" >> tbl_city.sql
        cnt=$((cnt+1))
    fi
done < regions_zh_state.csv
echo ";">> tbl_city.sql

## 插入国家
cnt=0
while read line
do
    IFS="," && arr=($line) && unset IFS
    if [ $cnt -eq 0 ]; then
        echo ";"
        echo -n ";insert into test.tbl_city(country_code,country_zh) values(\"${arr[0]}\", \"${arr[1]}\")" >> tbl_city.sql
        cnt=2
    elif [ $cnt -gt 100 ]; then
        echo ";"
        echo -n ";insert into test.tbl_city(country_code,country_zh) values(\"${arr[0]}\", \"${arr[1]}\")" >> tbl_city.sql
        cnt=1
    else
        echo -n ",(\"${arr[0]}\", \"${arr[1]}\")" >> tbl_city.sql
        cnt=$((cnt+1))
    fi
done < regions_zh_country.csv
echo ";">> tbl_city.sql

## 将地区的英文更新成中文
while read line
do
    IFS="," && arr=($line) && unset IFS
    echo "update test.tbl_city set state_zh='${arr[2]}' where country_code=\"${arr[0]}\" and state=\"${arr[1]}\";" >> tbl_city.sql 
done < regions_zh_state.csv

## 将国家的英文更新成中文
while read line
do
    IFS="," && arr=($line) && unset IFS
    echo "update test.tbl_city set country_zh='${arr[1]}' where country_code=\"${arr[0]}\";" >> tbl_city.sql
done < regions_zh_country.csv


################################################# tw ##################################################
awk 'BEGIN{FS="|";OFS=",";} $1=="zh_TW"{print $2,$3}' regions.txt |  awk 'BEGIN{FS="_";OFS=","} {print $1,$2,$3,$4}' | awk 'BEGIN{FS=",";OFS=","} $4!=""{print $1,$2,$3,$4}'  > regions_tw.csv  
awk 'BEGIN{FS="|";OFS=",";} $1=="zh_TW"{print $2,$3}' regions.txt |  awk 'BEGIN{FS="_";OFS=","} {print $1,$2,$3,$4}' | awk 'BEGIN{FS=",";OFS=","} $4==""&&$3!=""{print $1,$2,$3}'  > regions_tw_state.csv  
awk 'BEGIN{FS="|";OFS=",";} $1=="zh_TW"{print $2,$3}' regions.txt |  awk 'BEGIN{FS="_";OFS=","} {print $1,$2,$3,$4}' | awk 'BEGIN{FS=",";OFS=","} $3==""{print $1,$2}'  > regions_tw_country.csv  

conn="mysql -h192.168.15.81 -uroot -proot"

while read line
do
    IFS="," && arr=($line) && unset IFS
    echo "update test.tbl_city set city_tw=\"${arr[3]}\" where country_code=\"${arr[0]}\" and \`state\`=\"${arr[1]}\" and city=\"${arr[2]}\";" >> tbl_city.sql
done < regions_tw.csv

while read line
do
    IFS="," && arr=($line) && unset IFS
    echo "update test.tbl_city set state_tw='${arr[2]}' where country_code=\"${arr[0]}\" and state=\"${arr[1]}\";" >> tbl_city.sql
done < regions_tw_state.csv

## 将国家的英文更新成中文
while read line
do
    IFS="," && arr=($line) && unset IFS
    echo "update test.tbl_city set country_tw='${arr[1]}' where country_code=\"${arr[0]}\";" >> tbl_city.sql
done < regions_tw_country.csv


################################################# en ##################################################
awk 'BEGIN{FS="|";OFS=",";} $1=="en"{print $2,$3}' regions.txt |  awk 'BEGIN{FS="_";OFS=","} {print $1,$2,$3,$4}' | awk 'BEGIN{FS=",";OFS=","} $3==""{print $1,$2}'  > regions_en_country.csv  

conn="mysql -h192.168.15.81 -uroot -proot"

while read line
do
    IFS="," && arr=($line) && unset IFS
    echo "update test.tbl_city set country=\"${arr[1]}\" where country_code=\"${arr[0]}\";" >> tbl_city.sql
done < regions_en_country.csv

while read line
do
    $conn -N -e "$line"
done < tbl_city.sql
