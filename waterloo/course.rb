module Waterloo
  class Course
    attr_reader :code
    attr_accessor :name, :lecture, :tutorial, :lab, :test

    def initialize(code)
      @code = code
      yield self if block_given?
    end

    def time_slots
      [@lecture, @tutorial, @lab, @test].compact
    end
  end
end
