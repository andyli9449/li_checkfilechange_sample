
PLATFORM_ROOT=..
LDFLAG=
CFLAGS=
INC_DIR=
LIB_DIR=
LIBS=

#PLATFORM?=MT7688
PLATFORM?=X86_64
export INSTALL_PATH=$(PWD)

INC_DIR=$(PLATFORM_ROOT)/IISC
LIB_DIR=$(PLATFORM_ROOT)/IISC/lib/Linux/$(PLATFORM)


ifeq ("$(PLATFORM)","X86")
	CFLAGS+=-m32
	LDFLAGS+=-m32
endif


CC:=$(ICAT_CROSS_COMPILE)gcc
CPP:=$(ICAT_CROSS_COMPILE)g++
AR:=$(ICAT_CROSS_COMPILE)ar

CFLAGS+=-O2 -Wall -Wno-write-strings -D_LINUX
CPPFLAGS+=-std=c++11 
LDFLAG+=-O2 -ldl -pthread
STRIP = $(ICAT_CROSS_COMPILE)strip

CFLAGS+=-L$(LIB_DIR)
#LIBS+=$(LIB_DIR)/libsioclient.a

CFLAGS += -I$(INC_DIR)/include 
# Don't edit next variable, it will be modified automatically

# IISCLIB = $(LIB_DIR)/libiisc.a

RELEASE_OUTPUT = ./__out_bin
APP_SRC = ./test_main.cpp
#APP_SRC += ./include/lib_json/*.cpp
# LIBS_RELEASE =  $(IISCLIB)


default: test
# $(IISCLIB):
# 	(make install -C ../libiisc PLATFORM=$(PLATFORM))


test: #$(TSTOOLLIB)
	$(CPP) $(CFLAGS) $(CPPFLAGS) $(APP_SRC) $(LIBS_RELEASE) $(LIBS) $(LDFLAG) -o sample_$(PLATFORM)
	@echo === Target Platform [$(PLATFORM)] test Sample Done ===
	
clean:
ifeq ($(LIB),)
	rm -rf *.o *~ *.bak sample_$(PLATFORM)*
else
	(make -C ../$(LIB) cleanall PLATFORM=$(PLATFORM) ICAT_CROSS_COMPILE=$(ICAT_CROSS_COMPILE))
endif

cleanall: clean
#	(make -C ../libtstool cleanall PLATFORM=$(PLATFORM) ICAT_CROSS_COMPILE=$(ICAT_CROSS_COMPILE))
	rm -rf $(RELEASE_OUTPUT)

