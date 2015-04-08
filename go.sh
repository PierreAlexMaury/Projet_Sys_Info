#!/bin/bash

make clean
make
make clean
./compilateur < test_compilo.c
echo -------------------- ASM Temp  ---------------------------
cat ASM_temp.txt
echo -------------------- ASM final ---------------------------
cat ASM.txt
echo
echo -------------------- Interpreter -------------------------
./interpreter < ASM.txt
