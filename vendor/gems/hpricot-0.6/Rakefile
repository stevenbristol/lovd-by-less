require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
include FileUtils

NAME = "hpricot"
REV = `svn info`[/Revision: (\d+)/, 1] rescue nil
VERS = ENV['VERSION'] || "0.6" + (REV ? ".#{REV}" : "")
PKG = "#{NAME}-#{VERS}"
BIN = "*.{bundle,jar,so,obj,pdb,lib,def,exp}"
ARCHLIB = "lib/#{::Config::CONFIG['arch']}"
CLEAN.include ["ext/hpricot_scan/#{BIN}", "lib/**/#{BIN}", 'ext/hpricot_scan/Makefile', 
               '**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = ['--quiet', '--title', 'The Hpricot Reference', '--main', 'README', '--inline-source']
PKG_FILES = %w(CHANGELOG COPYING README Rakefile) +
      Dir.glob("{bin,doc,test,lib,extras}/**/*") + 
      Dir.glob("ext/**/*.{h,java,c,rb,rl}") + 
      %w[ext/hpricot_scan/hpricot_scan.c] # needed because it's generated later
SPEC =
  Gem::Specification.new do |s|
    s.name = NAME
    s.version = VERS
    s.platform = Gem::Platform::RUBY
    s.has_rdoc = true
    s.rdoc_options += RDOC_OPTS
    s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
    s.summary = "a swift, liberal HTML parser with a fantastic library"
    s.description = s.summary
    s.author = "why the lucky stiff"
    s.email = 'why@ruby-lang.org'
    s.homepage = 'http://code.whytheluckystiff.net/hpricot/'
    s.files = PKG_FILES
    s.require_paths = [ARCHLIB, "lib"] 
    s.extensions = FileList["ext/**/extconf.rb"].to_a
    s.bindir = "bin"
  end

desc "Does a full compile, test run"
task :default => [:compile, :test]

desc "Packages up Hpricot."
task :package => [:clean, :ragel]

desc "Releases packages for all Hpricot packages and platforms."
task :release => [:package, :package_win32, :package_jruby]

desc "Run all the tests"
Rake::TestTask.new do |t|
    t.libs << "test" << ARCHLIB
    t.test_files = FileList['test/test_*.rb']
    t.verbose = true
end

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.main = "README"
    rdoc.rdoc_files.add ['README', 'CHANGELOG', 'COPYING', 'lib/**/*.rb']
end

Rake::GemPackageTask.new(SPEC) do |p|
    p.need_tar = true
    p.gem_spec = SPEC
end

extension = "hpricot_scan"
ext = "ext/hpricot_scan"
ext_so = "#{ext}/#{extension}.#{Config::CONFIG['DLEXT']}"
ext_files = FileList[
  "#{ext}/*.c",
  "#{ext}/*.h",
  "#{ext}/*.rl",
  "#{ext}/extconf.rb",
  "#{ext}/Makefile",
  "lib"
] 

task "lib" do
  directory "lib"
end

desc "Compiles the Ruby extension"
task :compile => [:hpricot_scan] do
  if Dir.glob(File.join(ARCHLIB,"hpricot_scan.*")).length == 0
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    STDERR.puts "Gem actually failed to build.  Your system is"
    STDERR.puts "NOT configured properly to build hpricot."
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit(1)
  end
end
task :hpricot_scan => [:ragel]

desc "Builds just the #{extension} extension"
task extension.to_sym => ["#{ext}/Makefile", ext_so ]

file "#{ext}/Makefile" => ["#{ext}/extconf.rb"] do
  Dir.chdir(ext) do ruby "extconf.rb" end
end

file ext_so => ext_files do
  Dir.chdir(ext) do
    sh(PLATFORM =~ /win32/ ? 'nmake' : 'make')
  end
  mkdir_p ARCHLIB
  cp ext_so, ARCHLIB
end

desc "returns the ragel version"
task :ragel_version do
  @ragel_v = `ragel -v`[/(version )(\S*)/,2].to_f
end

desc "Generates the C scanner code with Ragel."
task :ragel => [:ragel_version] do
  sh %{ragel ext/hpricot_scan/hpricot_scan.rl | #{@ragel_v >= 5.18 ? 'rlgen-cd' : 'rlcodegen'} -G2 -o ext/hpricot_scan/hpricot_scan.c}
end

desc "Generates the Java scanner code with Ragel."
task :ragel_java => [:ragel_version] do
  sh %{ragel -J ext/hpricot_scan/hpricot_scan.java.rl | #{@ragel_v >= 5.18 ? 'rlgen-java' : 'rlcodegen'} -o  ext/hpricot_scan/HpricotScanService.java}
end

### Win32 Packages ###

Win32Spec = SPEC.dup
Win32Spec.platform = Gem::Platform::WIN32
Win32Spec.files = PKG_FILES + ["#{ARCHLIB}/hpricot_scan.so"]
Win32Spec.extensions = []
  
WIN32_PKG_DIR = "#{PKG}-mswin32"

desc "Package up the Win32 distribution."
file WIN32_PKG_DIR => [:package] do
  sh "tar zxf pkg/#{PKG}.tgz"
  mv PKG, WIN32_PKG_DIR
end

desc "Cross-compile the hpricot_scan extension for win32"
file "hpricot_scan_win32" => [WIN32_PKG_DIR] do
  cp "extras/mingw-rbconfig.rb", "#{WIN32_PKG_DIR}/ext/hpricot_scan/rbconfig.rb"
  sh "cd #{WIN32_PKG_DIR}/ext/hpricot_scan/ && ruby -I. extconf.rb && make"
  mv "#{WIN32_PKG_DIR}/ext/hpricot_scan/hpricot_scan.so", "#{WIN32_PKG_DIR}/#{ARCHLIB}"
end

desc "Build the binary RubyGems package for win32"
task :package_win32 => ["hpricot_scan_win32"] do
  Dir.chdir("#{WIN32_PKG_DIR}") do
    Gem::Builder.new(Win32Spec).build
    verbose(true) {
      mv Dir["*.gem"].first, "../pkg/#{WIN32_PKG_DIR}.gem"
    }
  end
end

CLEAN.include WIN32_PKG_DIR

### JRuby Packages ###

compile_java = proc do
  sh %{javac -source 1.4 -target 1.4 -classpath $JRUBY_HOME/lib/jruby.jar HpricotScanService.java}
  sh %{jar cf hpricot_scan.jar HpricotScanService.class}
end

desc "Compiles the JRuby extension"
task :hpricot_scan_java => [:ragel_java] do
  Dir.chdir("ext/hpricot_scan", &compile_java)
end

JRubySpec = SPEC.dup
JRubySpec.platform = 'jruby'
JRubySpec.files = PKG_FILES + ["#{ARCHLIB}/hpricot_scan.jar"]
JRubySpec.extensions = []

JRUBY_PKG_DIR = "#{PKG}-jruby"

desc "Package up the JRuby distribution."
file JRUBY_PKG_DIR => [:ragel_java, :package] do
  sh "tar zxf pkg/#{PKG}.tgz"
  mv PKG, JRUBY_PKG_DIR
end

desc "Cross-compile the hpricot_scan extension for JRuby"
file "hpricot_scan_jruby" => [JRUBY_PKG_DIR] do
  Dir.chdir("#{JRUBY_PKG_DIR}/ext/hpricot_scan", &compile_java)
  mv "#{JRUBY_PKG_DIR}/ext/hpricot_scan/hpricot_scan.jar", "#{JRUBY_PKG_DIR}/#{ARCHLIB}"
end

desc "Build the RubyGems package for JRuby"
task :package_jruby => ["hpricot_scan_jruby"] do
  Dir.chdir("#{JRUBY_PKG_DIR}") do
    Gem::Builder.new(JRubySpec).build
    verbose(true) {
      mv Dir["*.gem"].first, "../pkg/#{JRUBY_PKG_DIR}.gem"
    }
  end
end

CLEAN.include JRUBY_PKG_DIR

task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
