module Waterloo
  class CourseList
    def self.construct(course_data_list)
      course_data_list.map do |course_data|
        Waterloo::Course.new(course_data['code']) do |c|
          c.name = course_data['name']
          course_data['time_slots'].each do |time_slot_data|
            time_slot = Waterloo::TimeSlot.new(time_slot_data['meeting_info']) do |t|
              c.instructor ||= time_slot_data['instructor']
              t.instructor = time_slot_data['instructor']
              t.section = time_slot_data['section']
              t.locations = time_slot_data['locations']
            end
            c.add_time_slot(time_slot)
          end
        end
      end
    end
  end
end
