module Rake
  class Application
    DEFAULT_RAKEFILES = %w[Rakefile]
    def initialize
      @rakefiles = DEFAULT_RAKEFILES.dup
    end

    def run
      load_rakefile
      ARGV.each do |task_name|
        Rake::Task::Tasks[task_name].invoke
      end
    end

    def load_rakefile
      @rakefiles.each do |fn|
        if File.exist? fn
          load(fn)
        end
      end
    end
  end
end
