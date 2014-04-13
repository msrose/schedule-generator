module Waterloo
  class TimeSlot
    attr_reader :meeting_info
    attr_accessor :instructor, :section, :location

    def initialize(meeting_info)
      @meeting_info = meeting_info
      yield self if block_given?
    end

    def label
      ''
    end
  end

  class Lecture < TimeSlot
    def label
      'LEC'
    end
  end

  class Tutorial < TimeSlot
    def label
      'TUT'
    end
  end

  class Lab < TimeSlot
    def label
      'LAB'
    end
  end

  class Test < TimeSlot
    def label
      'TST'
    end
  end

  class Seminar < TimeSlot
    def label
      'SEM'
    end
  end
end
