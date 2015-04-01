#!/bin/bash

make clean
make
make clean
./compilateur < test_compilo.c
cat ASM_temp.txt
cat debbug_out.txt
cat ASM.txt


