#!/bin/bash

if [ $#  -ne 1 ]
then
	echo "Error: El parametro requiere al menos un parametro"
	echo "Ejemplo de uso:"
	echo -e "\t$0 127.0.0.1"
	exit 100
fi

PORT=7777
IP_SERVER=$1

IP_CLIENT=`ip a | grep -i inet | grep -i global | awk '{print $2}' | cut -d "/" -f 1` 

DATA=`nc -l $PORT` 

echo "LSTP Client"
echo "1. SEND HEADER" 
echo "LSTP_1" | nc $IP_SERVER $PORT

echo "2. LISTEN OK_HEADER" 
DATA=`nc -l $PORT`

echo "CHECK OK_HEADERS" 

if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR 1: HEADER enviado incorrectamente"
    exit 1 
fi 
 client / lechuga.lechu | text2wave - o client / lechuga.wav
 yes | ffmpeg - i client / lechuga.wav client / lechuga.ogg

echo "7. SEND FILE_NAME"

DATA=`nc -l $PORT`

echo "FILE_NAME lechuga.ogg" | nc $IP_SERVER $PORT

echo "8. LISTEN"

DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]
then
    echo "ERROR 2: FILE_NAME mal escrito"
    exit 2
fi

echo "12. SEND FILE_NAME"
cat lechga.ogg | nc $IP_SERVER $PORT

echo "13. LISTEN OK/KO_DATA"

DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_DATA" ] 
then
    echo "ERROR 3: Error al enviar datos"
    exit 3
fi

echo "16. SEND FILE_MD5"
MD5=`cat lechuga.ogg | md5sum | cut -d " " -f 1`
echo "FILE_DATA_MD5 $MD5" | nc $IP_SERVER $PORT

echo "17. LISTEN"
DATA=`nc -l $PORT`

echo "Fin"
exit 0
