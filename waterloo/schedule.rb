module Waterloo
  class Schedule
    attr_reader :courses

    attr_accessor :title
    attr_accessor :term
    attr_accessor :orientation
    attr_accessor :time_interval
    attr_accessor :legends
    attr_accessor :colors

    def initialize(courses = [])
      @courses = courses
      @orientation = :horizontal
      @legends = [:instructor, :location]
      @time_interval = :half_hour
    end

    def add(course)
      @courses.push(course)
    end

    def generate
      @courses.each { |course| p course }
    end
  end
end
