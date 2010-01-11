#!/bin/sh

mkdir -p bin
FNAME=`basename $1 .asm`
nasm -f elf $FNAME.asm -o bin/"$FNAME"_asm.o
gcc -c $FNAME.c -o bin/"$FNAME"_c.o
gcc bin/"$FNAME"_c.o bin/"$FNAME"_asm.o -o bin/$FNAME && bin/$FNAME

