# Waterloo Schedule Generator

Ruby utility for generating HTML schedules in a tabular, styled format.

## Configuration

Check out the [example configuration file](./config.example.json) for how to format your own configuration file.

API keys can be obtained from https://api.uwaterloo.ca/.

### api_key

A valid U Waterloo Open Data API key

### cache_http_requests

If `true`, the `generate` script will save data from any HTTP requests in a file; the saved data will be used in subsequent executions to avoid making excessive HTTP requests.

### cache_file_name

The name of the file to store data from HTTP requests.

### term

The four-digit code of the term for which you want to generate a schedule. See http://www.adm.uwaterloo.ca/infocour/CIR/SA/under.html.

### title

The title to be displayed above the schedule in the generated HTML.

### colors

An array of valid HTML color names/hexadecimal values that will be used to color code the schedule. Use one color for each course you're taking in the term.

### course_numbers

A list where each item is a list of related course numbers from https://uwaterloo.ca/quest/, found in the leftmost column under the list view for your class schedule.

For example, if I'm taking SE 380 this term and want lecture, tutorial, and lab to appear on my schedule, color-coded with the same color, I would specify

```
"course_numbers": [
  [8010,8011,8014]
]
```

where the numbers are the course numbers for lecture, tutorial and lab. If I'm also taking PHIL 226, which only has a lecture, I would specify

```
"course_numbers": [
  [8010,8011,8014],
  [4219]
]
```

## Generating a Schedule

```
$ ./generate config_file.json [output_file]
```

You must specify a config file with the above options in it, as in [the example config file](./config.example.json).
If you don't want to specify an output file, the generated HTML will be sent to STDOUT; otherwise, a file named `output_file` will be created, containing the generated HTML.

## A Note on Data Format

The `Schedule` class uses data in the following format to generate the schedule:

```
{
  "courses": [
    {
      "code": "CS 240",
      "name": "Data Structures and Data Management",
      "time_slots": [
        {
          "meeting_info": {
            "tuesday": ["14:30", "15:50"],
            "thursday": ["14:30", "15:50"]
          },
          "instructor": "Alejandro Lopez-Ortiz",
          "section": "LEC 001",
          "locations": {
            "default": "MC 2066"
          }
        },
        {
          "meeting_info": {
            "thursday": ["8:30", "9:20"]
          },
          "instructor": "",
          "section": "TUT 101",
          "locations": {
            "default": "OPT 1129"
          }
        }
      ]
    },
    {
      "code": "CS 247",
      "name": "Software Engineering Principles",
      "time_slots": [
        {
          "meeting_info": {
            "tuesday": ["10:00", "11:20"],
            "thursday": ["10:00", "11:20"]
          },
          "instructor": "Joanne Atlee",
          "section": "LEC 001",
          "locations": {
            "default": "MC 2065"
          }
        },
        {
          "meeting_info": {
            "friday": ["9:30", "10:20"]
          },
          "instructor": "",
          "section": "TUT 101",
          "locations": {
            "default": "MC 2065"
          }
        }
      ]
    }
  ]
}
```

The `CourseList` class can be used to generate a list of `Course` objects from a hash representation of the above JSON, which is then passed to a `Schedule` object on construction.

This format isn't the same as the Open Data API, so the `ApiConverter` was written to convert the API data to the appropriate format before constructing a list of `Course` objects with `CourseList.construct`.
