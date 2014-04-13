require './waterloo/course'
require './waterloo/timeslot'
require './waterloo/schedule'

cs240 = Waterloo::Course.new("CS 240") do |course|
  course.name = "Data Structures & Data Mgmt"
  course.lecture = Waterloo::Lecture.new [:tuesday, :thursday] => ["14:30", "15:50"] do |lec|
    lec.instructor = "Alejandro Lopez-Ortiz"
    lec.section = "001"
    lec.locations = ["MC 2066"]
  end
  course.tutorial = Waterloo::Tutorial.new thursday: ["8:30", "9:20"] do |tut|
    tut.section = "101"
    tut.locations = ["OPT 1129"]
  end
end

cs247 = Waterloo::Course.new("CS 247") do |course|
  course.name = "Software Engineering Principles"
  course.lecture = Waterloo::Lecture.new [:tuesday, :thursday] => ["10:00", "11:20"] do |lec|
    lec.instructor = "Joanne Atlee"
    lec.section = "001"
    lec.locations = ["MC 2065"]
  end
  course.tutorial = Waterloo::Tutorial.new friday: ["9:30", "10:20"] do |tut|
    tut.section = "101"
    tut.locations = ["MC 2065"]
  end
end

se202 = Waterloo::Course.new("SE 202") do |course|
  course.name = "Seminar"
  course.lecture = Waterloo::Seminar.new tuesday: ["11:30", "12:20"] do |lec|
    lec.instructor = "Daniel Berry"
    lec.section = "001"
    lec.locations = ["MC 1085"]
  end
end

engl140r = Waterloo::Course.new("ENGL 140R") do |course|
  course.name = "The Uses of English 1"
  course.lecture = Waterloo::Lecture.new [:monday, :wednesday] => ["16:00", "17:20"] do |lec|
    lec.instructor = "John Vardon"
    lec.section = "002"
    lec.locations = ["REN 2107"]
  end
end

math213 = Waterloo::Course.new("MATH 213") do |course|
  course.name = "Advanced Math for Software Eng"
  course.lecture = Waterloo::Lecture.new [:monday, :wednesday] => ["13:00", "14:20"] do |lec|
    lec.instructor = "John Thistle"
    lec.section = "001"
    lec.locations = ["MC 2066"]
  end
  course.tutorial = Waterloo::Tutorial.new wednesday: ["10:30", "11:20"] do |tut|
    tut.section = "101"
    tut.locations = ["MC 2066"]
  end
end

math239 = Waterloo::Course.new("MATH 239") do |course|
  course.name = "Intro to Combinatorics"
  course.lecture = Waterloo::Lecture.new [:monday, :wednesday, :friday] => ["14:30", "15:20"] do |lec|
    lec.instructor = "Alexander Nelson"
    lec.section = "004"
    lec.locations = ["MC 2066"]
  end
  course.tutorial = Waterloo::Tutorial.new friday: ["8:30", "9:20"] do |tut|
    tut.section = "104"
    tut.locations = ["AL 113"]
  end
end

msci261 = Waterloo::Course.new("MSCI 261") do |course|
  course.name = "Financial Management for Engineers"
  course.lecture = Waterloo::Lecture.new [:monday, :wednesday, :friday] => ["11:30", "12:20"] do |lec|
    lec.instructor = "Alexander Cozzarin"
    lec.section = "004"
    lec.locations = ["EV3 1408"]
  end
  course.tutorial = Waterloo::Tutorial.new wednesday: ["8:30", "9:20"] do |tut|
    tut.section = "104"
    tut.locations = ["CPH 1346"]
  end
end

Waterloo::Schedule.new([cs240, cs247, se202, engl140r, math213, math239, msci261]) do |schedule|
  schedule.title = "Michael Rose Software Engineering Schedule"
  schedule.term = "Spring 2014"
end.generate
