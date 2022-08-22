#!/usr/bin/perl

use strict;
use warnings;
use Mojo::DOM;
use LWP::UserAgent;
use Text::Trim qw(trim);
use DateTime::Format::Strptime;
use Dotenv -load;

my @events = CreateCalendarFile::get_table_from_url("https://www.iana.org/dnssec/ceremonies");

my $calendar_events = "";

for my $event (@events) {
    my $event_data = $event->find("td")->first;

    if ($event_data) {
        my $date = $event_data->text();
        my $description = $event->find("td")->last->all_text;
        my $ceremony_name = trim $event->find("td")->[1]->all_text;
        my $parser = DateTime::Format::Strptime->new(pattern => '%Y-%m-%d');
        my $datetime = $parser->parse_datetime($date);
        my $date_string = $datetime->strftime('%Y%m%d');

        if ($description) {
            $description =~ s/^\s+//;
            $description =~ s/\s+$//;
            $calendar_events .= CreateCalendarFile::create_event($date_string, $date_string, "KSKSIGNING", $ceremony_name, $description);
        }
    }
}

$calendar_events = CreateCalendarFile::create_calendar_object($calendar_events);
CreateCalendarFile::save_calendar_file($ENV{KSK_CALENDAR_FILE}, $calendar_events);