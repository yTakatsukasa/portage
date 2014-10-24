# SoftEther VPN Source Code
# 
# Copyright (c) 2012-2014 SoftEther VPN Project at University of Tsukuba, Japan.
# Copyright (c) 2012-2014 Daiyuu Nobori.
# All Rights Reserved.
# 
# http://www.softether.org/
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 2 as published by the Free Software Foundation.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License version 2
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
# 
# Platform: os=Linux, bits=32,64bit

# Variables

CC						:= gcc
AR						:= ar
DEBUG					?= 0
V						?= 0
BITS					?= 64
INSTALL_BINDIR			?=/usr/bin/
INSTALL_VPNSERVER_DIR	?=/usr/vpnserver/
INSTALL_VPNBRIDGE_DIR	?=/usr/vpnbridge/
INSTALL_VPNCLIENT_DIR	?=/usr/vpnclient/
INSTALL_VPNCMD_DIR		?=/usr/vpncmd/

CFLAGS		:= -fsigned-char
ifeq (${BITS},64)
CFLAGS		:= -m64
LDFLAGS		:= -m64
endif

CPPFLAGS	:= -MD -DUNIX -DUNIX_LINUX -DCPU_64 -D_REENTRANT -DREENTRANT -D_THREAD_SAFE -D_THREADSAFE -DTHREAD_SAFE -DTHREADSAFE -D_FILE_OFFSET_BITS=64
CPPFLAGS	+= -I./src/ -I./src/Cedar/ -I./src/Mayaqua/

ifeq (${DEBUG},1)
CPPFLAGS	:= -D_DEBUG -DDEBUG ${CPPFLAGS}
CFLAGS		:= -g
else
CPPFLAGS	:= -DNDEBUG -DVPN_SPEED ${CPPFLAGS}
CFLAGS		:= -O2
endif

ifeq ($V,1)
SHOW_CMD_LINE   := 
SHOW_MSG        := > /dev/null
else
SHOW_CMD_LINE   := @
SHOW_MSG        :=
endif

LDFLAGS	+= -lm -ldl -lrt -lpthread -lssl -lcrypto -lreadline -lncurses -lz

OBJECTS_MAYAQUA := $(addprefix tmp/objs/Mayaqua/,$(subst .c,.o,$(notdir $(wildcard src/Mayaqua/*.c))))
OBJECTS_CEDAR	:= $(addprefix tmp/objs/Cedar/,$(subst .c,.o,$(notdir $(wildcard src/Cedar/*.c))))
ALL_DEP_FILES	= $(wildcard tmp/*/*.d)

HAMCORE_FILES	:= \
	src/bin/hamcore/authors.txt \
	src/bin/hamcore/backup_dir_readme.txt \
	src/bin/hamcore/empty.config \
	src/bin/hamcore/empty_sevpnclient.config \
	src/bin/hamcore/eula.txt \
	src/bin/hamcore/install_src.dat \
	src/bin/hamcore/lang.config \
	src/bin/hamcore/languages.txt \
	src/bin/hamcore/legal.txt \
	src/bin/hamcore/openvpn_readme.pdf \
	src/bin/hamcore/openvpn_readme.txt \
	src/bin/hamcore/openvpn_sample.ovpn \
	src/bin/hamcore/root_certs.dat \
	src/bin/hamcore/SOURCES_OF_BINARY_FILES.TXT \
	src/bin/hamcore/strtable_cn.stb \
	src/bin/hamcore/strtable_en.stb \
	src/bin/hamcore/strtable_ja.stb \
	src/bin/hamcore/vpnweb_sample_cn.htm \
	src/bin/hamcore/vpnweb_sample_en.htm \
	src/bin/hamcore/vpnweb_sample_ja.htm \
	src/bin/hamcore/warning_cn.txt \
	src/bin/hamcore/warning_en.txt \
	src/bin/hamcore/warning_ja.txt \
	src/bin/hamcore/webui/cryptcom.cgi \
	src/bin/hamcore/webui/edituser.cgi \
	src/bin/hamcore/webui/error.cgi \
	src/bin/hamcore/webui/hub.cgi \
	src/bin/hamcore/webui/license.cgi \
	src/bin/hamcore/webui/listener.cgi \
	src/bin/hamcore/webui/localbridge.cgi \
	src/bin/hamcore/webui/login.cgi \
	src/bin/hamcore/webui/newhub.cgi \
	src/bin/hamcore/webui/redirect.cgi \
	src/bin/hamcore/webui/securenat.cgi \
	src/bin/hamcore/webui/server.cgi \
	src/bin/hamcore/webui/session.cgi \
	src/bin/hamcore/webui/user.cgi \
	src/bin/hamcore/webui/webui.css

# Build Action
.PHONY:default build prepare help clean
default: build

build: prepare bin/vpnserver bin/vpnclient bin/vpnbridge bin/vpncmd

prepare:
	@mkdir -p tmp/
	@mkdir -p tmp/objs/
	@mkdir -p tmp/objs/Mayaqua/
	@mkdir -p tmp/objs/Cedar/
	@mkdir -p tmp/objs/hamcorebuilder
	@mkdir -p tmp/objs/vpnserver
	@mkdir -p tmp/objs/vpnclient
	@mkdir -p tmp/objs/vpnbridge
	@mkdir -p tmp/objs/vpncmd
	@mkdir -p tmp/as/
	@mkdir -p bin/
	@ln -sf vpncsvc.c src/vpnclient/vpnclient.c

tmp/objs/%.o:src/%.c
	@echo Compiling $@ $(SHOW_MSG)
	$(SHOW_CMD_LINE) $(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

tmp/as/%.a:
	@echo Archiving $@ $(SHOW_MSG)
	$(SHOW_CMD_LINE) rm -f $@
	$(SHOW_CMD_LINE) $(AR) cru $@ $^

bin/%:tmp/as/%.a
	@echo Linking $@ $(SHOW_MSG)
	$(SHOW_CMD_LINE) $(CC) $< $(LDFLAGS) -o $@

tmp/as/vpnserver.a:tmp/objs/vpnserver/vpnserver.o $(OBJECTS_MAYAQUA) $(OBJECTS_CEDAR)
tmp/as/vpnclient.a:tmp/objs/vpnclient/vpnclient.o $(OBJECTS_MAYAQUA) $(OBJECTS_CEDAR)
tmp/as/vpnbridge.a:tmp/objs/vpnbridge/vpnbridge.o $(OBJECTS_MAYAQUA) $(OBJECTS_CEDAR)
tmp/as/vpncmd.a:tmp/objs/vpncmd/vpncmd.o $(OBJECTS_MAYAQUA) $(OBJECTS_CEDAR)

# hamcore.se2 Archive File
bin/hamcore.se2: tmp/hamcorebuilder $(HAMCORE_FILES)
	@mkdir -p src/bin/BuiltHamcoreFiles/unix/
	tmp/hamcorebuilder src/bin/hamcore/ $@

# hamcorebuilder Utility
tmp/hamcorebuilder: tmp/objs/hamcorebuilder/hamcorebuilder.o $(OBJECTS_MAYAQUA) $(OBJECTS_CEDAR)
	@echo Linkng $@
	@$(CC) $^ $(LDFLAGS) -o $@

# Install
install: $(INSTALL_BINDIR)vpnserver $(INSTALL_BINDIR)vpnbridge $(INSTALL_BINDIR)vpnclient $(INSTALL_BINDIR)vpncmd
	@echo
	@echo "--------------------------------------------------------------------"
	@echo "Installation completed successfully."
	@echo
	@echo "Execute 'vpnserver start' to run the SoftEther VPN Server background service."
	@echo "Execute 'vpnbridge start' to run the SoftEther VPN Bridge background service."
	@echo "Execute 'vpnclient start' to run the SoftEther VPN Client background service."
	@echo "Execute 'vpncmd' to run SoftEther VPN Command-Line Utility to configure VPN Server, VPN Bridge or VPN Client."
	@echo "--------------------------------------------------------------------"
	@echo

$(INSTALL_BINDIR)vpnserver: bin/hamcore.se2 bin/vpnserver
	@mkdir -p $(INSTALL_VPNSERVER_DIR)
	cp bin/hamcore.se2 $(INSTALL_VPNSERVER_DIR)hamcore.se2
	cp bin/vpnserver $(INSTALL_VPNSERVER_DIR)vpnserver
	echo "#!/bin/sh" > $(INSTALL_BINDIR)vpnserver
	echo $(INSTALL_VPNSERVER_DIR)vpnserver '"$$@"' >> $(INSTALL_BINDIR)vpnserver
	echo 'exit $$?' >> $(INSTALL_BINDIR)vpnserver
	chmod 755 $(INSTALL_BINDIR)vpnserver

$(INSTALL_BINDIR)vpnbridge: bin/hamcore.se2 bin/vpnbridge
	@mkdir -p $(INSTALL_VPNBRIDGE_DIR)
	cp bin/hamcore.se2 $(INSTALL_VPNBRIDGE_DIR)hamcore.se2
	cp bin/vpnbridge $(INSTALL_VPNBRIDGE_DIR)vpnbridge
	echo "#!/bin/sh" > $(INSTALL_BINDIR)vpnbridge
	echo $(INSTALL_VPNBRIDGE_DIR)vpnbridge '"$$@"' >> $(INSTALL_BINDIR)vpnbridge
	echo 'exit $$?' >> $(INSTALL_BINDIR)vpnbridge
	chmod 755 $(INSTALL_BINDIR)vpnbridge

$(INSTALL_BINDIR)vpnclient: bin/hamcore.se2 bin/vpnclient
	@mkdir -p $(INSTALL_VPNCLIENT_DIR)
	cp bin/hamcore.se2 $(INSTALL_VPNCLIENT_DIR)hamcore.se2
	cp bin/vpnclient $(INSTALL_VPNCLIENT_DIR)vpnclient
	echo "#!/bin/sh" > $(INSTALL_BINDIR)vpnclient
	echo $(INSTALL_VPNCLIENT_DIR)vpnclient '"$$@"' >> $(INSTALL_BINDIR)vpnclient
	echo 'exit $$?' >> $(INSTALL_BINDIR)vpnclient
	chmod 755 $(INSTALL_BINDIR)vpnclient

$(INSTALL_BINDIR)vpncmd: bin/hamcore.se2 bin/vpncmd
	@mkdir -p $(INSTALL_VPNCMD_DIR)
	cp bin/hamcore.se2 $(INSTALL_VPNCMD_DIR)hamcore.se2
	cp bin/vpncmd $(INSTALL_VPNCMD_DIR)vpncmd
	echo "#!/bin/sh" > $(INSTALL_BINDIR)vpncmd
	echo $(INSTALL_VPNCMD_DIR)vpncmd '"$$@"' >> $(INSTALL_BINDIR)vpncmd
	echo 'exit $$?' >> $(INSTALL_BINDIR)vpncmd
	chmod 755 $(INSTALL_BINDIR)vpncmd

# Clean
clean:
	rm -rf bin tmp

# Help Strings
help:
	@echo "make [DEBUG=1] [BITS={32,64}] [V=1]"
	@echo "make install"
	@echo "make clean"

-include $(ALL_DEP_FILES)
