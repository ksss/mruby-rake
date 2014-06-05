module Rake
  class Task
    Tasks = {}
    attr_accessor :prerequisites

    class << self
      def [](task_name)
        Tasks[task_name]
      end

      def define_task(args, &block)
        name, deps = resolve_args(args)
        t = Rake::Task.new(name)
        t.enhance(deps, &block)
        Tasks[name] = t
        t
      end

      def resolve_args(args)
        case args
        when Hash
          n = args.keys[0]
          [n.to_s, args[n].flatten]
        else
          [args.to_s, []]
        end
      end
    end

    def initialize(name)
      @name = name
      @prerequisites = []
      @actions = []
      @invoked = false
    end

    def name
      @name.to_s
    end

    def invoke
      return if @invoked
      @prerequisites.each do |d|
        Task[d].invoke
      end
      @actions.each do |b| b.call(self) end
      @invoked = true
    end

    def enhance(d, &b)
      @prerequisites = d.map{|n| n.to_s}
      @actions << b
      self
    end
  end
end
