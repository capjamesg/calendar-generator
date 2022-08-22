# Calendar Monitors

Scripts to create calendars to which you can subscribe for public lists of events.

## How it Works

This project contains scripts that retrieve publicly accessible web pages and returns a structured `.ics` file with all of the events the script is programmed to find.

At the moment, this repository has scripts for monitoring:

- Google Search algorithm updates
- IANA Root KSK Signing ceremonies

## Getting Started

First, install the required dependencies for this project. The following dependencies are needed:

- Mojo::DOM
- LWP::UserAgent
- Text::Trim
- DateTime::Format::Strptime
- Dotenv

You can install these dependencies using `cpan install [dependency_name]`.

Next, create a `.env` file. This file must contain one value:

    CALENDAR_FILE=/path/to/new_file

`CALENDAR_FILE` must point to the name of the file to which you want to write the calendar in a script. You should explicitly state the `.ics` extension at the end of the calendar path file name.

Next, run the script that interests you. You can do this using the following command:

    perl [script_name].pl

This script will retrieve the events on the page that is specified in the script you have run and save them in a `.ics` file.

You can add this `.ics` file to your calendar to import past events. Or, you can make the file available via a URL so you can subscribe to it. Subscribing to the calendar lets you follow new events, as long as you periodically run the script to search for new events.

You may want to add an entry into your cron file so that the script updates the calendar file every day or on a cadence most suitable to your needs. For the Google and IANA updates, a daily cadence would suffice since the pages are not updated regularly.

The following crontab entry will run a Perl script every day at 1am:

    0 1 * * * perl /path/to/perl/file.pl

## Language

This project is built in Perl.

## License

This project is licensed under an [MIT license](LICENSE).

## Author

- capjamesg