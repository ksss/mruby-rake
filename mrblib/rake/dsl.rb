module Rake
  module DSL
    def task(args, &block)
      Rake::Task.define_task(args, &block)
    end
  end
end

