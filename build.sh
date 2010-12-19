#!/bin/sh -x

APPNAME=ScreenReplay
BNDLDIR=./${APPNAME}.app/Contents/MacOS
SRC="main MyMenu MyDelegate Global HotKey"
SRC="${SRC} Recorder Video Scanner"
SRC="${SRC} Audio "

mkdir -p ${BNDLDIR}
rm ${BNDLDIR}/${APPNAME}

for i in ${SRC}; do gcc -c ${i}.m -o ${i}.o ; done

# Carbon => HotKey
# QuartzCore => CV...(Core Video)
FWORKS=" -framework Cocoa -framework Carbon -framework QuartzCore"
FWORKS="${FWORKS} -framework OpenGL -framework QTKit "

gcc ${FWORKS} *.o -o ${APPNAME}

mv ${APPNAME} ${BNDLDIR}

for i in ${SRC}; do rm ${i}.o; done

