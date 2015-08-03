module Waterloo
  class ApiConverter
    def self.convert(unconverted_data)
      course_data_list = []
      unconverted_data.each do |ud|
        api_data = ud[0]
        changed_data = {}

        code = "#{api_data['subject']} #{api_data['catalog_number']}"
        changed_data['code'] = code

        name = api_data['title']
        changed_data['name'] = name

        time_slots = []

        ud.each do |number_data|
          time_slot = {}
          number_data['classes'].each do |c|
            time_slot['meeting_info'] = {}
            time_slot['locations'] = {}
            class_days = parse_days(c['date']['weekdays'])
            class_days.each do |day|
              time_slot['meeting_info'][day] = [c['date']['start_time'], c['date']['end_time']]
              time_slot['locations'][day] = "#{c['location']['building']} #{c['location']['room']}"
            end
            time_slot['instructor'] = c['instructors'].map { |i| i.split(',').reverse.join(' ') }.join(', ')
            time_slot['section'] = number_data['section']
          end
          time_slots.push(time_slot)
        end

        changed_data['time_slots'] = time_slots

        course_data_list.push(changed_data)
      end
      course_data_list
    end

    private
      DAYS = { 'M' => 'monday', 'T' => 'tuesday', 'W' => 'wednesday', 'Th' => 'thursday', 'F' => 'friday' }

      def self.parse_days(letter_string)
        day_list = []
        letter_string.split('').each_with_index do |c, i|
          next_c = letter_string[i + 1]
          if next_c && DAYS[c + next_c]
            day_list.push(DAYS[c + next_c])
          elsif DAYS[c]
            day_list.push(DAYS[c])
          end
        end
        day_list
      end
  end
end
