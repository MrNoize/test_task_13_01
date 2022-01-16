#!/bin/bash
wget -q -O list.out https://raw.githubusercontent.com/GreatMedivack/files/master/list.out
if [ -n "$1" ]
then
	SERVER=$1
else
	SERVER=SERVER
fi
DATE=`date +%d_%m_%y`
SERVER_DATE=${SERVER}_${DATE}
awk '$3=="Error" || $3=="CrashLoopBackOff"{print $1}' list.out > ${SERVER_DATE}_failed.out
awk '$3=="Running"{print $1}' list.out > ${SERVER_DATE}_running.out
sed -i -r 's/\-[a-f0-9]{9,10}\-[a-z0-9]{5}$//g' ${SERVER_DATE}*.out
running_s=`cat ${SERVER_DATE}_running.out | wc -l`
failed_s=`cat ${SERVER_DATE}_failed.out | wc -l`
restarted_s=`awk '$4 > 0 && NR > 1{print $1}' list.out | wc -l`
user=${USER}
date=`date +%d/%m/%y`
printf "Количество работающих сервисов: %u\nКоличество сервисов с ошибками: %u\nКоличество перезапустившихся сервисов: %u\nИмя системного пользователя: %s\nДата: %s\n" $running_s $failed_s $restarted_s $user $date > ${SERVER_DATE}_report.out
chmod ugo+r ${SERVER_DATE}_report.out
tar -cz -f "${SERVER_DATE}" ${SERVER_DATE}*.out
mkdir -p archives
mv -n -t archives ${SERVER_DATE}
rm ${SERVER_DATE}*.out list.out
tar -tvzf archives/${SERVER_DATE} >/dev/null && echo "Архив не поврежден. Скрипт завершил свою работу." || echo "Архив поврежден."
