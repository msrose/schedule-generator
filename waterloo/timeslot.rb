module Waterloo
  class TimeSlot
    attr_reader :meeting_info, :id
    attr_accessor :instructor, :section, :locations

    def initialize(meeting_info)
      @meeting_info = meeting_info
      @@id ||= 0
      @id = (@@id += 1)
      yield self if block_given?
    end
  end
end
