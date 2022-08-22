#!/usr/bin/perl

use strict;
use warnings;
use Mojo::DOM;
use LWP::UserAgent;
use Text::Trim qw(trim);
use DateTime::Format::Strptime;
use Dotenv -load;

use lib "./";
use CreateCalendarFile;

my @events = CreateCalendarFile::get_table_from_url("https://developers.google.com/search/updates/ranking");

my $calendar_events = "";

for my $event (@events) {
    my $event_data = $event->find("td")->first;

    if ($event_data) {
        my $date = $event_data->at("h3")->text();
        my $description = $event->find("td")->last->all_text;
        my $parser = DateTime::Format::Strptime->new(pattern => '%B %e, %Y');
        my $datetime = $parser->parse_datetime($date);
        my $date_string = $datetime->strftime('%Y%m%d');

        if ($description) {
            $description =~ s/^\s+//;
            $description =~ s/\s+$//;
            $calendar_events .= CreateCalendarFile::create_event($date_string, $date_string, "GOOGLEUPDATES", "Google Update - $date", $description);
        }
    }
}

$calendar_events = CreateCalendarFile::create_calendar_object($calendar_events);
CreateCalendarFile::save_calendar_file($ENV{GOOGLE_UPDATES_CAL_FILE}, $calendar_events);
