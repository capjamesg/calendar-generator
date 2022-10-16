# Calendar Monitors

Scripts to create calendars to which you can subscribe for public lists of events.

## How it Works

This project contains scripts that retrieve publicly accessible web pages and returns a structured `.ics` file with all of the events the script is programmed to find.

At the moment, this repository has scripts for monitoring:

- [Google Search algorithm updates](https://developers.google.com/search/updates/ranking) (cal.pl)
- [IANA Root KSK Signing ceremonies](https://www.iana.org/dnssec/ceremonies) (ksk.pl)
- [IndieWeb Timeline](https://indieweb.org/timeline) (indiewebevents.pl)

## Getting Started

First, install the required dependencies for this project. The following dependencies are needed:

- Mojo::DOM
- LWP::UserAgent
- Text::Trim
- DateTime::Format::Strptime
- Dotenv

You can install these dependencies using `cpan install [dependency_name]`.

Next, create a `.env` file. This file must contain the path where you want to save the `.ical` file for each script you use.

The available values are:

    GOOGLE_UPDATES_CALENDAR_FILE=/path/to/new_file
    KSK_CALENDAR_FILE=/path/to/new_file
    INDIEWEB_CALENDAR_FILE =/path/to/new_file

Each value must point to the name of the file to which you want to write the calendar in a script. You should explicitly state the `.ics` extension at the end of the calendar path file name. You only need to specify a value for the variable the script(s) you plan to run will use.

Next, run the script that interests you. You can do this using the following command:

    perl [script_name].pl

This script will retrieve the events on the page that is specified in the script you have run and save them in a `.ics` file.

You can add this `.ics` file to your calendar to import past events. Or, you can make the file available via a URL so you can subscribe to it. Subscribing to the calendar lets you follow new events, as long as you periodically run the script to search for new events.

You may want to add an entry into your cron file so that the script updates the calendar file every day or on a cadence most suitable to your needs. For the Google, IANA, and IndieWeb updates, a daily cadence would suffice since the pages are not updated regularly.

The following crontab entry will run a Perl script every day at 1am:

    0 1 * * * perl /path/to/perl/file.pl

## Language

This project is built in Perl.

## License

This project is licensed under an [MIT 0 license](LICENSE).

## Author

- capjamesg