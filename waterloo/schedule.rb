require 'erb'

module Waterloo
  class Schedule
    DAYS = [:monday, :tuesday, :wednesday, :thursday, :friday]
    MINUTES_PER_SLOT = 30
    DAY_START_TIME = '8:30'
    TIME_FORMAT = '%d:%02d'

    attr_reader :courses
    attr_accessor :title, :term, :orientation, :legends, :colors

    def initialize(courses = [])
      @courses = courses
      @orientation = :horizontal
      @legends = [:course_name, :instructor]
      @colors = ['white']
      yield self if block_given?

      interval_size = time_interval_size(DAY_START_TIME, calculate_day_end)
      @day_start_minute_val = minute_value(DAY_START_TIME)
      @grid = Hash[DAYS.zip(Array.new(DAYS.length) { Array.new(interval_size) })]
      initialize_time_markers(interval_size)
      populate_grid
    end

    def add(course)
      @courses.push(course)
    end

    def generate
      puts ERB.new(File.open('./waterloo/template.rhtml').read).result(binding).gsub(/^\s+/, '')
    end

    private

      def populate_grid
        @courses.each_with_index do |course, k|
          course.time_slots.each do |time_slot|
            time_slot.meeting_info.each do |days, (start_time, end_time)|
              first_slot = (minute_value(start_time) - @day_start_minute_val) / MINUTES_PER_SLOT
              last_slot = first_slot + time_interval_size(start_time, end_time)
              [days].flatten.each do |day|
                day_symbol = day.to_sym
                for i in first_slot...last_slot
                  if @grid[day_symbol][i].nil?
                    @grid[day_symbol][i] = {
                      id: time_slot.id,
                      text: course.code + '<br>' + time_slot.section + '<br>' + time_slot.locations.first,
                      color: @colors[k % @colors.count]
                    }
                  else
                    raise "Time conflict for #{course.code} from #{start_time} - #{end_time}"
                  end
                end
              end
            end
          end
        end
      end

      def time_interval_size(start_time, end_time)
        (minute_value(end_time) - minute_value(start_time) + 10) / MINUTES_PER_SLOT
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

      def initialize_time_markers(interval_size)
        @time_markers = (0...interval_size).to_a.map do |el|
          min_val = @day_start_minute_val + MINUTES_PER_SLOT * el
          TIME_FORMAT % min_val.divmod(60)
        end
      end

      def calculate_span_value(id, index, time_slots)
        span = 1
        while (index += 1) < time_slots.length
          break unless time_slots[index] && time_slots[index][:id] == id
          span += 1
        end
        span
      end

      def twelve_hour_time(time)
        hour, minute = time.split(':').map(&:to_i)
        if hour <= 12
          time
        else
          TIME_FORMAT % [hour - 12, minute]
        end
      end
  end
end
