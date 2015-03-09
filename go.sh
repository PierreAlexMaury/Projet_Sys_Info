#!/bin/bash

make clean
make
make clean
./compilateur < test_compilo.c
