
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = /usr/local/lib/ruby/1.8/i686-darwin8.10.3
hdrdir = $(topdir)
VPATH = $(srcdir):$(topdir):$(hdrdir)
prefix = $(DESTDIR)/usr/local
exec_prefix = $(prefix)
sitedir = $(prefix)/lib/ruby/site_ruby
rubylibdir = $(libdir)/ruby/$(ruby_version)
docdir = $(datarootdir)/doc/$(PACKAGE)
dvidir = $(docdir)
datarootdir = $(prefix)/share
archdir = $(rubylibdir)/$(arch)
sbindir = $(exec_prefix)/sbin
psdir = $(docdir)
localedir = $(datarootdir)/locale
htmldir = $(docdir)
datadir = $(datarootdir)
includedir = $(prefix)/include
infodir = $(datarootdir)/info
sysconfdir = $(prefix)/etc
mandir = $(datarootdir)/man
libdir = $(exec_prefix)/lib
sharedstatedir = $(prefix)/com
oldincludedir = $(DESTDIR)/usr/include
pdfdir = $(docdir)
sitearchdir = $(sitelibdir)/$(sitearch)
bindir = $(exec_prefix)/bin
localstatedir = $(prefix)/var
sitelibdir = $(sitedir)/$(ruby_version)
libexecdir = $(exec_prefix)/libexec

CC = gcc
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static

RUBY_EXTCONF_H = 
CFLAGS   =  -fno-common -g -O2  -fno-common -pipe -fno-common -D_FILE_OFFSET_BITS=64 
INCFLAGS = -I. -I$(topdir) -I$(hdrdir) -I$(srcdir)
CPPFLAGS =  
CXXFLAGS = $(CFLAGS) 
DLDFLAGS =   
LDSHARED = cc -dynamic -bundle -undefined suppress -flat_namespace
AR = ar
EXEEXT = 

RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = ruby
arch = i686-darwin8.10.3
sitearch = i686-darwin8.10.3
ruby_version = 1.8
ruby = /usr/local/bin/ruby
RUBY = $(ruby)
RM = rm -f
MAKEDIRS = mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp

#### End of system configuration section. ####

preload = 

libpath = $(libdir)
LIBPATH =  -L"$(libdir)"
DEFFILE = 

CLEANFILES = 
DISTCLEANFILES = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED)  -lpthread -ldl -lobjc  
SRCS = analysis.c api.c array.c bitvector.c compound_io.c document.c except.c ferret.c filter.c fs_store.c global.c hash.c hashset.c helper.c index.c libstemmer.c mempool.c multimapper.c posh.c priorityqueue.c q_boolean.c q_const_score.c q_filtered_query.c q_fuzzy.c q_match_all.c q_multi_term.c q_parser.c q_phrase.c q_prefix.c q_range.c q_span.c q_term.c q_wildcard.c r_analysis.c r_index.c r_qparser.c r_search.c r_store.c r_utils.c ram_store.c search.c similarity.c sort.c stem_ISO_8859_1_danish.c stem_ISO_8859_1_dutch.c stem_ISO_8859_1_english.c stem_ISO_8859_1_finnish.c stem_ISO_8859_1_french.c stem_ISO_8859_1_german.c stem_ISO_8859_1_italian.c stem_ISO_8859_1_norwegian.c stem_ISO_8859_1_porter.c stem_ISO_8859_1_portuguese.c stem_ISO_8859_1_spanish.c stem_ISO_8859_1_swedish.c stem_KOI8_R_russian.c stem_UTF_8_danish.c stem_UTF_8_dutch.c stem_UTF_8_english.c stem_UTF_8_finnish.c stem_UTF_8_french.c stem_UTF_8_german.c stem_UTF_8_italian.c stem_UTF_8_norwegian.c stem_UTF_8_porter.c stem_UTF_8_portuguese.c stem_UTF_8_russian.c stem_UTF_8_spanish.c stem_UTF_8_swedish.c stopwords.c store.c term_vectors.c utilities.c
OBJS = analysis.o api.o array.o bitvector.o compound_io.o document.o except.o ferret.o filter.o fs_store.o global.o hash.o hashset.o helper.o index.o libstemmer.o mempool.o multimapper.o posh.o priorityqueue.o q_boolean.o q_const_score.o q_filtered_query.o q_fuzzy.o q_match_all.o q_multi_term.o q_parser.o q_phrase.o q_prefix.o q_range.o q_span.o q_term.o q_wildcard.o r_analysis.o r_index.o r_qparser.o r_search.o r_store.o r_utils.o ram_store.o search.o similarity.o sort.o stem_ISO_8859_1_danish.o stem_ISO_8859_1_dutch.o stem_ISO_8859_1_english.o stem_ISO_8859_1_finnish.o stem_ISO_8859_1_french.o stem_ISO_8859_1_german.o stem_ISO_8859_1_italian.o stem_ISO_8859_1_norwegian.o stem_ISO_8859_1_porter.o stem_ISO_8859_1_portuguese.o stem_ISO_8859_1_spanish.o stem_ISO_8859_1_swedish.o stem_KOI8_R_russian.o stem_UTF_8_danish.o stem_UTF_8_dutch.o stem_UTF_8_english.o stem_UTF_8_finnish.o stem_UTF_8_french.o stem_UTF_8_german.o stem_UTF_8_italian.o stem_UTF_8_norwegian.o stem_UTF_8_porter.o stem_UTF_8_portuguese.o stem_UTF_8_russian.o stem_UTF_8_spanish.o stem_UTF_8_swedish.o stopwords.o store.o term_vectors.o utilities.o
TARGET = ferret_ext
DLLIB = $(TARGET).bundle
EXTSTATIC = 
STATIC_LIB = 

RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR = /Users/steve/rails/lovd-by-less/vendor/gems/ferret-0.11.4/bin$(target_prefix)
RUBYARCHDIR = /Users/steve/rails/lovd-by-less/vendor/gems/ferret-0.11.4/bin$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).bundle $(TARGET).il? $(TARGET).tds $(TARGET).map
CLEANOBJS     = *.o *.a *.s[ol] *.pdb *.exp *.bak

all:		$(DLLIB)
static:		$(STATIC_LIB)

clean:
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean:	clean
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)

realclean:	distclean
install: install-so install-rb

install-so: $(RUBYARCHDIR)
install-so: $(RUBYARCHDIR)/$(DLLIB)
$(RUBYARCHDIR)/$(DLLIB): $(DLLIB)
	$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
$(RUBYARCHDIR):
	$(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .cxx .cpp .C .o

.cc.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.cxx.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.cpp.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.C.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.c.o:
	$(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) -c $<

$(DLLIB): $(OBJS)
	@-$(RM) $@
	$(LDSHARED) $(DLDFLAGS) $(LIBPATH) -o $@ $(OBJS) $(LOCAL_LIBS) $(LIBS)



$(OBJS): ruby.h defines.h
