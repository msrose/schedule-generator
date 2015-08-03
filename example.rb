require 'json'

require './waterloo/course'
require './waterloo/timeslot'
require './waterloo/schedule'
require './waterloo/api_converter'
require './waterloo/api_client'

config = JSON.parse(File.open('./config.json').read)
client = Waterloo::ApiClient.new(config['api_key'], config['term'])

api_data = []

config['course_numbers'].each do |list|
  data_list = []
  list.each do |n|
    data_list.push(client.get_course(n))
  end
  api_data.push(data_list)
end

course_data_list = Waterloo::ApiConverter.convert(api_data)

courses = []

course_data_list.each do |course_data|
  course = Waterloo::Course.new(course_data['code']) do |c|
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
  courses.push(course)
end

schedule = Waterloo::Schedule.new(courses) do |s|
  s.title = 'Michael Rose Software Engineering Schedule'
  s.term = 'Spring 2014'
  s.colors = ['orange', '#4D4DFF', 'red', 'yellow', '#339933', 'pink', 'cyan']
end

puts schedule.generate
