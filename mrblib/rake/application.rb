module Rake
  class Application
    DEFAULT_RAKEFILES = %w[Rakefile]

    def initialize
      @rakefiles = DEFAULT_RAKEFILES.dup
      @rakefile = nil
      @original_dir = Dir.pwd
      @tasks = []
    end

    def run
      init
      load_rakefile
      top_level
    rescue StandardError => e
      puts "rake aborted!"
      puts e
      Dir.chdir(@original_dir)
    end

    def init
      if ARGV.size == 0
        @tasks.push('default')
      else
        ARGV.each do |arg|
          @tasks.push arg
        end
      end
    end

    def load_rakefile
      rakefile, location = find_rakefile
      fail "No Rakefile found (looking for: #{@rakefiles.join(', ')})" if rakefile.nil?
      @rakefile = rakefile
      Dir.chdir(location)
      print_load_file File.expand_path(@rakefile)
      load(File.expand_path(@rakefile)) if @rakefile && @rakefile != ''
    end

    def top_level
      if Rake::Task::Tasks.has_key?('default')
        @tasks.each do |task_name|
          Rake::Task::Tasks[task_name].invoke
        end
      else
        fail "Don't know how to build task 'default'"
      end
    end

    def find_rakefile
      here = Dir.pwd
      until (fn = have_rakefile)
        Dir.chdir("..")
        return nil if Dir.pwd == here
        here = Dir.pwd
      end
      [fn, here]
    ensure
      Dir.chdir(@original_dir)
    end

    def have_rakefile
      @rakefiles.each do |fn|
        if File.exist?(fn)
          return fn
        end
      end
      return nil
    end

    def print_load_file(filename)
      puts "load Rakefile: #{filename}"
    end
  end
end
