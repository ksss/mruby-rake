module Rake
  class Application
    attr_accessor :tasks

    DEFAULT_RAKEFILES = %w[Rakefile rakefile Rakefile.rb rakefile.rb]

    def initialize
      @rakefiles = DEFAULT_RAKEFILES.dup
      @rakefile = nil
      @original_dir = Dir.pwd
      @tasks = {}
    end

    def run
      init
      load_rakefile
      top_level
    rescue Exception => e
      puts "mrake aborted!"
      p e
      Dir.chdir(@original_dir)
    end

    def init
      @argv = ARGV.dup
    end

    def define_task(task_klass, *args, &block)
      name, deps = resolve_args(args)
      t = task_klass.new(name)
      @tasks[name] = t
      deps = deps.map{|d| d.to_s}
      t.enhance(deps, &block)
      t
    end

    def resolve_args(args)
      task_name = args.first
      case task_name
      when Hash
        n = task_name.keys[0]
        [n.to_s, task_name[n].flatten]
      else
        [task_name.to_s, []]
      end
    end

    def load_rakefile
      rakefile, location = find_rakefile
      fail "No Rakefile found (looking for: #{@rakefiles.join(', ')})" if rakefile.nil?
      @rakefile = rakefile
      print_load_file File.expand_path(@rakefile) if location != @original_dir
      Dir.chdir(location)
      load(File.expand_path(@rakefile)) if @rakefile && @rakefile != ''
    end

    def top_level
      if Rake.application.tasks.has_key?('default')
        @tasks['default'].invoke
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
      nil
    end

    def print_load_file(filename)
      puts "(in : #{filename})"
    end
  end
end
