require 'json'

require './waterloo/course'
require './waterloo/timeslot'
require './waterloo/schedule'
require './waterloo/api_converter'
require './waterloo/api_client'

config = JSON.parse(File.open('./config.json').read)
client = Waterloo::ApiClient.new(config['api_key'], config['term'])

api_data = []
term = {}

if config['cache_http_requests'] && File.exists?('./cache.json')
  cache = JSON.parse(File.open('./cache.json').read)

  api_data = cache['data'] || api_data
  term = cache['term'] || term

  STDERR.puts 'Read data from cache file. (To get the latest data, delete the file.)'
elsif
  term = client.get_term(config['term'])
  STDERR.puts "Got data for #{term['name']} term."

  config['course_numbers'].each do |list|
    data_list = []

    list.each do |n|
      data_list.push(client.get_course(n))
    end

    api_data.push(data_list)
    course = data_list[0]

    STDERR.puts "Got data for #{course['subject']} #{course['catalog_number']}: #{course['title']}."
  end

  cache_data = { 'data' => api_data, 'term' => term }

  if config['cache_http_requests']
    File.open('./cache.json', 'w+') { |file| file.write(cache_data.to_json) }
    STDERR.puts 'Cached data in file cache.json.'
  end
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
  s.title = config['title'] || ''
  s.term = term['name'] || ''
  s.colors = config['colors'] || []
end

puts schedule.generate
