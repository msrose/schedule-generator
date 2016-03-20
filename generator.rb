require './waterloo/course'
require './waterloo/course_list'
require './waterloo/timeslot'
require './waterloo/schedule'
require './waterloo/api_converter'
require './waterloo/api_client'

class Generator
  def self.create_schedule(config)
    client = Waterloo::ApiClient.new(config['api_key'], config['term'])
    cache_file_name = config['cache_file_name']

    api_data = []
    term = {}

    if config['cache_http_requests'] && File.exists?(cache_file_name)
      cache = JSON.parse(File.open(cache_file_name).read)

      api_data = cache['data'] || api_data
      term = cache['term'] || term

      STDERR.puts "Read data from #{cache_file_name}. (To get the latest data, delete the file.)"
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
        File.open(cache_file_name, 'w+') { |file| file.write(cache_data.to_json) }
        STDERR.puts "Cached data in file #{cache_file_name}."
      end
    end

    course_data_list = Waterloo::ApiConverter.convert(api_data)
    courses = Waterloo::CourseList.construct(course_data_list)

    schedule = Waterloo::Schedule.new(courses) do |s|
      s.title = config['title'] || ''
      s.term = term['name'] || ''
      s.colors = config['colors'] || []
    end

    schedule.generate
  end
end
