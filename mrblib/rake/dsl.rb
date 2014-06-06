module Rake
  module DSL
    def task(args, &block)
      Rake::Task.define_task(args, &block)
    end

    def cd(path)
      puts "cd #{path}"
      Dir.chdir path
    end

    def sh(command)
      puts "sh #{command}"
      system command
    end
  end
end

