module Rake
  module DSL
    def task(*args, &block)
      Rake::Task.define_task(*args, &block)
    end

    def file(*args, &block)
      Rake::FileTask.define_task(*args, &block)
    end

    def cd(path, &block)
      puts "cd #{path}"
      if block
        Dir.chdir(path, &block)
        puts "cd -"
      else
        Dir.chdir(path)
      end
    end

    def sh(command)
      puts command
      system command
    end
  end
end

