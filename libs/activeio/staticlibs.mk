
ACTIVEIOSTREAM_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/activeio/vsrc/*.c)
ACTIVEIOSTREAM_VSOURCE_BASE=$(basename $(notdir $(ACTIVEIOSTREAM_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(ACTIVEIOSTREAM_VSOURCE_BASE)))

