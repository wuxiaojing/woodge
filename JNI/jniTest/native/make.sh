#! /bin/sh

#目录定义

#生成的目标文件名
TARG_NAME=libJniDemo.so

#编译标识，打开为编译动态库，关闭为编译可执行程序
export SHARED=1

#源代码所在的主目录
SRC_ROOT=src
#测试代码所在的主目录
#TEST_SRC_ROOT="test"


#用到的库的目录
LIB_ROOT=../LIB/
LIB_ROOT_R=${LIB_ROOT}
LIB_ROOT_D=${LIB_ROOT}

MAKETOOLS="Maketools/"
#用到的头文件所在目录
INCS_FILE="${MAKETOOLS}Makefile.inc"
#用到的库存放的路径
LIBS_FILE="${MAKETOOLS}Makefile.libs"

MAKEFILE_MAK="${MAKETOOLS}Makefile.mak"
MAKEFILE_PUB="${MAKETOOLS}Makefile.pub"

#记住当前目录
ROOT_DIR=`pwd`

#包含的目录列表
INC_DIRLIST=""
#C++文件名列表
SRC_CPPLIST=""
#C文件名列表
SRC_CLIST=""


#brief 查询目录下的子目录
#param[in] 查找的目录
function get_include_dirs ()
{
    MAIN_PATH=$1
    echo --current dir path: ${MAIN_PATH}

    #添加子目录
    SRC_TMP=`find ${MAIN_PATH} -type d | grep -v '.svn'`
    for dir_name in ${SRC_TMP}
    do
        #添加目录list
        INC_DIRLIST+=" -I"
        INC_DIRLIST+=${dir_name}

        #echo --sub_dir--- ${dir_name}
    done
}

#brief 获取目录下的C、C++文件，保存到相应的全局变量中
#param[in] 查找的目录
function get_src_files()
{
    MAIN_PATH=$1
    echo --current src path: ${MAIN_PATH}

    #找目录下的C++文件
    SRC_TMP=`find ${MAIN_PATH} -name "*.cpp"`
    #保存待添加的C++文件
    for src_file in ${SRC_TMP}
    do
        SRC_CPPLIST+=" "
        SRC_CPPLIST+=$src_file

        #打印找到的文件
        #echo --c++-- ${src_file}
    done

    #找目录下的C文件
    SRC_TMP=`find ${MAIN_PATH} -name "*.c"`
    #保存待添加的C文件
    for src_file in ${SRC_TMP}
    do
        SRC_CLIST+=" "
        SRC_CLIST+=$src_file

        #打印找到的文件
        #echo --c-- ${src_file}
    done

	#获取目录列表
	get_include_dirs  ${MAIN_PATH}

}

#获取要编译的文件以及文件所在的目录
get_src_files ${SRC_ROOT}
#添加测试代码
if [ ${TEST_SRC_ROOT} ]; then
	get_src_files ${TEST_SRC_ROOT}
fi

#添加头文件所在目录
#如果文件名不为空
if [ ${INCS_FILE} ] ; then
	if [ -r ${INCS_FILE} ] ; then
		echo --------------------------------------------------------

		while read LINE
		do 
			#跳过注释行
			case ${LINE} in
				\#*)
					#echo --sub_dir--- ${LINE}
					continue
					;;
				*) 
					if [ -n "${LINE}" ]; then
						#添加目录list
						INC_DIRLIST+=" -I"
						INC_DIRLIST+=${LINE} 
						echo ---include dir--: ${LINE}
					fi
					;;
			esac
		done < ${INCS_FILE}
	else
		echo "file \"${INCS_FILE}\" which contain include path is not exist."
	fi
fi

#添加库文件所在目录
#如果文件名不为空
if [ ${LIBS_FILE} ] ; then
	if [ -r ${LIBS_FILE} ] ; then

		echo --------------------------------------------------------

		while read LINE
		do 
			#跳过注释行
			case ${LINE} in
				\#*)
					#echo ---lib dir--: ${LINE}
					continue
					;;
				*) 
					if [ -n "${LINE}" ]; then
						#添加目录list
						LIB_DIRLIST+=" -L"
						LIB_DIRLIST+=${LINE} 
						echo ---lib dir--: ${LINE}
					fi
					;;
			esac
		done < ${LIBS_FILE}
	else
		echo "file \"${INCS_FILE}\" which contain include path is not exist."
	fi
fi
#exit 0

export TARG_NAME
export SRC_CPPLIST
export SRC_CLIST
export INC_DIRLIST
export LIB_DIRLIST
export MAKEFILE_PUB

#echo $LD_LIBRARY_PATH

TEST=0
if [ 1 -eq $TEST ]; then

	echo 
	echo " target file: " ${TARG_NAME}
	echo " c file list: " ${SRC_CLIST}
	echo "cpp filelist: " ${SRC_CPPLIST}
	echo "include dirs: " ${INC_DIRLIST}
	echo
	exit 0
fi

echo --------------------------------------------------------

case "$1" in
	r|release)
		  echo "comple ${TARG_NAME} of release..."
		  export LIB_DIRLIST+=" -L"${LIB_ROOT_R}
		  #echo $LIB_DIRLIST
		  make -f ${MAKEFILE_MAK} COMPILE=release
		  exit $?
		  ;;
	d|debug)
		  echo "comple ${TARG_NAME} of debug..."
		  export LIB_DIRLIST+=" -L"${LIB_ROOT_D}
		  export LD_LIBRARY_PATH=${LIB_ROOT_D}:$LD_LIBRARY_PATH
		  #echo ${LIB_DIRLIST}
		  make -f ${MAKEFILE_MAK} COMPILE=debug
		  exit $?
		  ;;
	cr|clear_release)
		  echo "clean and comple ${TARG_NAME} of release..."
		  export LIB_DIRLIST+=" -L"${LIB_ROOT_R}
		  #echo $LIB_DIRLIST
		  make -f ${MAKEFILE_MAK} COMPILE=release clean;make -f ${MAKEFILE_MAK} COMPILE=release
		  exit $?
		  ;;
	cd|clear_debug)
		  echo "clean and comple ${TARG_NAME} of debug..."
		  export LIB_DIRLIST+=" -L"${LIB_ROOT_D}
		  #echo $LIB_DIRLIST
		  make -f ${MAKEFILE_MAK} COMPILE=debug clean;make -f ${MAKEFILE_MAK} COMPILE=debug
		  exit $?
		  ;;
	clr|clean_reases)
		  echo "clean and comple ${TARG_NAME} of debug..."
		  export LIB_DIRLIST+=" -L"${LIB_ROOT_R}
		  make -f ${MAKEFILE_MAK} COMPILE=reases clean
		  exit 0
		  ;;
	cld|clean_debug)
		  echo "clean and comple ${TARG_NAME} of debug..."
		  export LIB_DIRLIST+=" -L"${LIB_ROOT_D}
		  make -f ${MAKEFILE_MAK} COMPILE=debug clean
		  exit 0
		  ;;
	install)
		  usr_include="usr/include"
		  usr_lib="usr/lib" 
		  
		  rm -rf ${usr_include}
		  rm -rf ${usr_lib} 
		  mkdir -p ${usr_include} 2>/dev/null
		  mkdir -p ${usr_lib} 2>/dev/null
		  find src -name "*.h" -exec cp {} ${usr_include} \;
		  cp ${TARG_NAME} ${usr_lib}
		  exit 0
		  ;;
	i)
		  DEST=/home/antispam/AntiRun/V100R003C06LGC112/AntiSpamming2850
		  echo cp ${TARG_NAME} ${DEST}
		  cp ${TARG_NAME} ${DEST}
		  echo 
		  ;;
	*)
		  echo "------------------------------------------"    
		  echo "./make.sh release        :comple ${TARG_NAME} of release."
		  echo "./make.sh debug          :comple ${TARG_NAME} of debug."
		  echo "./make.sh clear_release  :clean and comple ${TARG_NAME} of release."
		  echo "./make.sh clear_debug    :clean and comple ${TARG_NAME} of debug."
		  echo "------------------------------------------" 
		  exit 1
		  ;;
esac
