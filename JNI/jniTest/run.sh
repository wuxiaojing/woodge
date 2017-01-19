#!/bin/bash
# CLASSPATH 需要包含./
# 编辑 ${NPATH}/Maketools/Makefile.inc 修改jni头文件路径 

hprintf(){
	echo -e "\033[35m $1 \033[0m"
}

JNINAME="JniDemo"
# c++ 路径:含inc、lib、src、makefile
NPATH='native'
# java 包路径
PPATH="com/wxj/jni/demo"
PNAME="com.wxj.jni.demo"

hprintf "编译class文件"
javac ${JNINAME}.java -d ./
ls ${PPATH}/*.class -l

hprintf "生成jni头文件"
javah -d ${NPATH}/inc -classpath ./ ${PNAME}.${JNINAME}
ls ${NPATH}/inc/* -l

hprintf "编译so文件"
cd ${NPATH}
./make.sh clear_debug
cd ../
ls ${NPATH}/lib/* -l

hprintf "运行class文件"
java -Djava.library.path=${NPATH}/lib ${PPATH}/${JNINAME}
