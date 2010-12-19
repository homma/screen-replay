#!/bin/sh

BKDIR=history/`date '+%Y-%m%d-%H%M.%S'`
export BKDIR

mkdir -p ${BKDIR}
cp *.m *.h ${BKDIR}
cp *.sh ${BKDIR}

# cp *.txt ${BKDIR}

