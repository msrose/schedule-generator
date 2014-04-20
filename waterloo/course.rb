module Waterloo
  class Course
    attr_reader :code, :time_slots
    attr_accessor :name, :type, :instructor

    def initialize(code)
      @code = code
      @time_slots = []
      yield self if block_given?
    end

    def add_time_slot(time_slot)
      @time_slots.push(time_slot)
    end
  end
end
