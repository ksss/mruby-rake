module Rake
  class << self
    def application
      @application ||= Rake::Application.new
    end
  end
end
