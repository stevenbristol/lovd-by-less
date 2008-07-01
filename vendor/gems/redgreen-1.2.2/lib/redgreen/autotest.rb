Autotest.send(:alias_method, :real_ruby, :ruby)
Autotest.send(:define_method, :ruby) do |*args|
    real_ruby + %[ -rrubygems -e "require 'redgreen'" ] 
end

if PLATFORM =~ /win32/ 
  require 'win32console' 
  Autotest.send(:define_method, :run_tests) do |*args|
      find_files_to_test # failed + changed/affected
      cmd = make_test_cmd @files_to_test

      hook :run_command
      puts cmd
      old_sync = $stdout.sync
      $stdout.sync = true
      @results = []
      line = []
      begin
        open("| #{cmd}", "r") do |f|
          until f.eof? do
            c = f.getc
            #~ putc c
            line << c
            if c == ?\n then
              @results << line.pack("c*")
              line.clear
            end
          end
        end
      ensure
        $stdout.sync = old_sync
      end
      puts @results
      hook :ran_command
      @results = @results.join
      handle_results(@results)
    end
    
    Autotest.add_hook(:ran_command) do |at| p
      include Term::ANSIColor
      at.results = at.results.map{ |r| uncolored(r) }
    end
end
