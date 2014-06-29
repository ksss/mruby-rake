module Rake
  class Task
    class << self
      def define_task(*args, &block)
        Rake.application.define_task(self, *args, &block)
      end
    end

    def initialize(name)
      @name = name
      @prerequisites = []
      @actions = []
      @already_invoked = false
    end

    def name
      @name.to_s
    end

    def invoke
      return if @already_invoked
      return unless needed?

      @prerequisites.each do |p|
        Rake.application.tasks[p].invoke
      end
      @actions.each do |b| b.call(self) end
      @already_invoked = true
    end

    def enhance(d, &b)
      @prerequisites |= d if d
      @actions << b if b
      self
    end

    def reenable
      @already_invoked = false
    end

    def needed?
      true
    end
  end

  class FileTask < Task
    def needed?
      !File.exist?(name) || out_of_date?(timestamp)
    end

    def timestamp
      if File.exist?(name)
        File::Stat.new(name).mtime
      else
        0
      end
    end

    def out_of_date?(stamp)
      @prerequisites.any? { |n| Rake.application.tasks[n].timestamp > stamp }
    end
  end
end
