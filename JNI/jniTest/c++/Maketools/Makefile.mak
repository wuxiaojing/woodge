#Ŀ¼����ʶmakefile.pub���ڵ�Ŀ¼
ROOT_PATH=.
#���ɿ�ִ���ļ���Ŀ¼
TARGETDIR=lib
#���ɵĳ�����
NAME=${TARG_NAME}

#��Ϊrelease�汾���ر���debug�汾
ifeq ($(COMPILE),release)
    NDEBUG=1
    DEBUG_DEFINE=-DWITH_OPENSSL -DSOAP_DEBUG -D_LINUX -D_ORACLE -D_PLATFORM64_ -fno-inline -DNDEBUG 
else
    #NDEBUG=1
    DEBUG_DEFINE=-DWITH_OPENSSL -DSOAP_DEBUG -D_LINUX -D_ORACLE -D_PLATFORM64_ -fno-inline
endif


#C++���뼯
#SRC=$(shell ls *.cpp)
SRC=${SRC_CPPLIST}

#C���뼯
SRC_CC=${SRC_CLIST}

#ͷ�ļ��������
INC+=${INC_DIRLIST}
#��������Ŀ��ļ�
LIB_DIR=${LIB_DIRLIST}

ifdef NDEBUG
 # release���������
 LIB=-lz  
 CXXFLAGS=-finput-charset=GB18030 -fexec-charset=UTF8 $(DEBUG_DEFINE) 
else
 # debug���������
 LIB=-lz 
 CXXFLAGS=-finput-charset=GB18030 -fexec-charset=UTF8 $(DEBUG_DEFINE) 
endif

include ${MAKEFILE_PUB}
