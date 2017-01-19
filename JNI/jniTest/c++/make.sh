#! /bin/sh

#Ŀ¼����

#���ɵ�Ŀ���ļ���
TARG_NAME=libJniDemo.so

#�����ʶ����Ϊ���붯̬�⣬�ر�Ϊ�����ִ�г���
export SHARED=1

#Դ�������ڵ���Ŀ¼
SRC_ROOT=src
#���Դ������ڵ���Ŀ¼
#TEST_SRC_ROOT="test"


#�õ��Ŀ��Ŀ¼
LIB_ROOT=../LIB/
LIB_ROOT_R=${LIB_ROOT}
LIB_ROOT_D=${LIB_ROOT}

MAKETOOLS="Maketools/"
#�õ���ͷ�ļ�����Ŀ¼
INCS_FILE="${MAKETOOLS}Makefile.inc"
#�õ��Ŀ��ŵ�·��
LIBS_FILE="${MAKETOOLS}Makefile.libs"

MAKEFILE_MAK="${MAKETOOLS}Makefile.mak"
MAKEFILE_PUB="${MAKETOOLS}Makefile.pub"

#��ס��ǰĿ¼
ROOT_DIR=`pwd`

#������Ŀ¼�б�
INC_DIRLIST=""
#C++�ļ����б�
SRC_CPPLIST=""
#C�ļ����б�
SRC_CLIST=""


#brief ��ѯĿ¼�µ���Ŀ¼
#param[in] ���ҵ�Ŀ¼
function get_include_dirs ()
{
    MAIN_PATH=$1
    echo --current dir path: ${MAIN_PATH}

    #�����Ŀ¼
    SRC_TMP=`find ${MAIN_PATH} -type d | grep -v '.svn'`
    for dir_name in ${SRC_TMP}
    do
        #���Ŀ¼list
        INC_DIRLIST+=" -I"
        INC_DIRLIST+=${dir_name}

        #echo --sub_dir--- ${dir_name}
    done
}

#brief ��ȡĿ¼�µ�C��C++�ļ������浽��Ӧ��ȫ�ֱ�����
#param[in] ���ҵ�Ŀ¼
function get_src_files()
{
    MAIN_PATH=$1
    echo --current src path: ${MAIN_PATH}

    #��Ŀ¼�µ�C++�ļ�
    SRC_TMP=`find ${MAIN_PATH} -name "*.cpp"`
    #�������ӵ�C++�ļ�
    for src_file in ${SRC_TMP}
    do
        SRC_CPPLIST+=" "
        SRC_CPPLIST+=$src_file

        #��ӡ�ҵ����ļ�
        #echo --c++-- ${src_file}
    done

    #��Ŀ¼�µ�C�ļ�
    SRC_TMP=`find ${MAIN_PATH} -name "*.c"`
    #�������ӵ�C�ļ�
    for src_file in ${SRC_TMP}
    do
        SRC_CLIST+=" "
        SRC_CLIST+=$src_file

        #��ӡ�ҵ����ļ�
        #echo --c-- ${src_file}
    done

	#��ȡĿ¼�б�
	get_include_dirs  ${MAIN_PATH}

}

#��ȡҪ������ļ��Լ��ļ����ڵ�Ŀ¼
get_src_files ${SRC_ROOT}
#��Ӳ��Դ���
if [ ${TEST_SRC_ROOT} ]; then
	get_src_files ${TEST_SRC_ROOT}
fi

#���ͷ�ļ�����Ŀ¼
#����ļ�����Ϊ��
if [ ${INCS_FILE} ] ; then
	if [ -r ${INCS_FILE} ] ; then
		echo --------------------------------------------------------

		while read LINE
		do 
			#����ע����
			case ${LINE} in
				\#*)
					#echo --sub_dir--- ${LINE}
					continue
					;;
				*) 
					if [ -n "${LINE}" ]; then
						#���Ŀ¼list
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

#��ӿ��ļ�����Ŀ¼
#����ļ�����Ϊ��
if [ ${LIBS_FILE} ] ; then
	if [ -r ${LIBS_FILE} ] ; then

		echo --------------------------------------------------------

		while read LINE
		do 
			#����ע����
			case ${LINE} in
				\#*)
					#echo ---lib dir--: ${LINE}
					continue
					;;
				*) 
					if [ -n "${LINE}" ]; then
						#���Ŀ¼list
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
