#目录，标识makefile.pub所在的目录
ROOT_PATH=.
#生成可执行文件的目录
TARGETDIR=lib
#生成的程序名
NAME=${TARG_NAME}

#打开为release版本，关闭是debug版本
ifeq ($(COMPILE),release)
    NDEBUG=1
    DEBUG_DEFINE=-DWITH_OPENSSL -DSOAP_DEBUG -D_LINUX -D_ORACLE -D_PLATFORM64_ -fno-inline -DNDEBUG 
else
    #NDEBUG=1
    DEBUG_DEFINE=-DWITH_OPENSSL -DSOAP_DEBUG -D_LINUX -D_ORACLE -D_PLATFORM64_ -fno-inline
endif


#C++代码集
#SRC=$(shell ls *.cpp)
SRC=${SRC_CPPLIST}

#C代码集
SRC_CC=${SRC_CLIST}

#头文件依赖添加
INC+=${INC_DIRLIST}
#添加依赖的库文件
LIB_DIR=${LIB_DIRLIST}

ifdef NDEBUG
 # release库依赖添加
 LIB=-lz  
 CXXFLAGS=-finput-charset=GB18030 -fexec-charset=UTF8 $(DEBUG_DEFINE) 
else
 # debug库依赖添加
 LIB=-lz 
 CXXFLAGS=-finput-charset=GB18030 -fexec-charset=UTF8 $(DEBUG_DEFINE) 
endif

include ${MAKEFILE_PUB}
