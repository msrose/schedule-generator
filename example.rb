require './waterloo/course'
require './waterloo/timeslot'
require './waterloo/schedule'

cs240 = Waterloo::Course.new("CS 240") do |course|
  course.name = "Data Structures & Data Mgmt"
  course.lecture = Waterloo::Lecture.new [:tuesday, :thursday] => ["14:30", "15:50"] do |lec|
    lec.instructor = "Alejandro Lopez-Ortiz"
    lec.section = "001"
    lec.location = "MC 2066"
  end
  course.tutorial = Waterloo::Tutorial.new thursday: ["8:30", "9:20"] do |tut|
    tut.section = "101"
    tut.location = "OPT 1129"
  end
end

Waterloo::Schedule.new([cs240]).generate
