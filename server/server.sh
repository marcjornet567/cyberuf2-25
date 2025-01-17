#!/bin/bash
PORT=7777
IP_CLIENT="localhost"

echo "SERVIDOR LSTP"

echo "0. LISTEN"

DATA=`nc -l $PORT`

echo "3. CHECK HEADER"

if [ "$DATA" != "LSTP_1" ]
then
	echo "ERROR 1: Header mal formado $DATA"
    echo "KO_HEADER" | nc $IP_CLIENT $PORT
    exit 1
fi

IP_CLIENT=`echo "$DATA" | cut -d " " -f 2`

echo "4. SEND OK_HEADER"

echo "OK_HEADER" | nc $IP_CLIENT $PORT

echo "5. LISTEN FILE_NAME"

DATA=`nc -l $PORT`

echo "9. CHECK FILE_NAME"

PREFIX=`echo $DATA | cut -d " " -f 1`

if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "ERROR 2: FILE_NAME incorrecto"
    echo "KO_FILE_NAME" | nc $IP_CLIENT $PORT
    exit 2
fi

FILE_NAME=`echo $DATA | cut -d " " -f 2`
echo "10. SEND OK_FILE_NAME"

echo "OK_FILE_NAME" | nc $IP_CLIENT $PORT

echo "11. LISTEN FILE_DATA"

DATA=`nc - l $PORT`

nc -l $PORT > server / $FILE_NAME

echo "14. SEND OK_FILE_DATA"

DATA=`cat server / $FILE_NAME | wc - c`

if [ $FILE_NAME -eq 0 ]
then
    echo "ERROR 4: DATOS MAL FORMADOS (vacio) "
    echo "KO_FILE_DATA" | nc $IP_CLIENT $PORT
    exit 4
fi
echo "15. LISTEN FILE_MD5"
DATA_MD5=`nc -l $PORT`

echo "18.CHECK DATA_MD5"

if [ "$DATA_MD5 | cut -d " " -f 1" != "FILE_DATA_MD5" ]
then
	echo "ERROR 5: FILE_DATA_MD5 mal formado"
 	echo "KO_FILE_DATA_MD5" | nc $IP_CLIENT $PORT
 	exit 5
fi

echo "19.CHECK MD5"
if [ "$DATA_MD5 | cut -d " " -f 2" != "cdea0ac7b8cfe90c2a87f394e588e1b8" ]
then

	echo "ERROR 6: FILE_MD5 no coincide"
	echo "KO_FILE_DATA_MD5" | nc $IP_CLIENT $PORT
	exit 6
fi

echo "OK_FILE_DATA_MD5"

echo "Fin"
exit 0
