#!/bin/bash

make clean
make
make clean
./compilateur < test_compilo.c
if test -s ASM_temp.txt; then
	echo -------------------- ASM Temp  ---------------------------
	cat ASM_temp.txt
	echo -------------------- ASM final ---------------------------
	cat ASM.txt
fi
./interpreter < ASM.txt
