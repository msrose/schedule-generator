require 'erb'

module Waterloo
  DAYS = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

  class Schedule
    attr_reader :courses, :day_start, :day_end, :grid
    attr_accessor :title, :term, :orientation, :legends, :colors

    def initialize(courses = [])
      @courses = courses
      @orientation = :horizontal
      @legends = [:instructor, :location]
      @day_start = "8:30"
      @day_end = calculate_day_end
      @interval_size = time_interval_size(@day_start, @day_end)
      @day_start_minute_val = minute_value(@day_start)
      @time_markers = (0...@interval_size).to_a.map do |el|
        min_val = @day_start_minute_val + 30 * el
        "%d:%02d" % min_val.divmod(60)
      end
      populate_grid
      yield self if block_given?
    end

    def add(course)
      @courses.push(course)
    end

    def generate
      puts ERB.new(File.open('./waterloo/template.rhtml').read).result(binding).gsub(/^\s+|\s+$/, '')
    end

    private

      def populate_grid
        @grid = Hash[DAYS.zip(Array.new(DAYS.length) { Array.new(@interval_size) })]
        @courses.each do |course|
          course.time_slots.each do |time_slot|
            time_slot.meeting_info.each do |days, (start_time, end_time)|
              time_slot_size = time_interval_size(start_time, end_time)
              start_time_minute_val = minute_value(start_time)
              [days].flatten.each do |day|
                first_slot = (start_time_minute_val - @day_start_minute_val) / 30
                (first_slot...(first_slot + time_slot_size)).each do |i|
                  @grid[day][i] = course.code + ' ' + time_slot.label
                end
              end
            end
          end
        end
      end

      def time_interval_size(start_time, end_time)
        (minute_value(end_time) - minute_value(start_time) + 10) / 30.0
      end

      def minute_value(time)
        hour, minute = time.split(':').map(&:to_i)
        hour * 60 + minute
      end

      def calculate_day_end
        times = @courses.collect(&:time_slots).flatten.collect(&:meeting_info).map(&:values).flatten
        times.sort do |a, b|
          minute_value(a) <=> minute_value(b)
        end.last
      end
  end
end
