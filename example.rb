require 'json'
require './waterloo/course'
require './waterloo/timeslot'
require './waterloo/schedule'

courses = []

JSON.parse(File.open('./data.json').read)["courses"].each do |course_data|
  course = Waterloo::Course.new(course_data["code"]) do |c|
    c.name = course_data["name"]
    course_data["time_slots"].each do |time_slot_data|
      time_slot = Waterloo::TimeSlot.new(time_slot_data["meeting_info"]) do |t|
        c.instructor ||= time_slot_data["instructor"]
        t.instructor = time_slot_data["instructor"]
        t.section = time_slot_data["section"]
        t.locations = time_slot_data["locations"]
      end
      c.add_time_slot(time_slot)
    end
  end
  courses.push(course)
end

Waterloo::Schedule.new(courses) do |schedule|
  schedule.title = 'Michael Rose Software Engineering Schedule'
  schedule.term = 'Spring 2014'
  schedule.colors = ['orange', 'blue', 'red', 'yellow', 'green', 'pink', 'cyan']
  # schedule.orientation = :vertical
end.generate
