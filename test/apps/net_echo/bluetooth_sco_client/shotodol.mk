
# This makefile is parsed by shotodol make module 

all:
	help module
	help fileconf
	module -load ../../../../apps/net_echo/plugin.so
	net_echo -send SCO://00:18:E7:37:27:61:00:22:58:F6:AA:99 -chunk_size 42 -interval 100 -dryrun yes
	noconsole
