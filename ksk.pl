#!/usr/bin/perl

use strict;
use warnings;
use Mojo::DOM;
use Text::Trim qw(trim);
use DateTime::Format::Strptime;
use Dotenv -load;

use lib "./";
use CreateCalendarFile;

sub get_ksk_events {
    my @events = CreateCalendarFile::get_table_from_url("https://www.iana.org/dnssec/ceremonies");

    my $calendar_events = "";

    my $event_count = 0;

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
                $calendar_events .= CreateCalendarFile::create_event($date_string, $date_string, "KSKSIGNING", $ceremony_name, $description, "", $event_count);

                $event_count += 1;
            }
        }
    }

    $calendar_events = CreateCalendarFile::create_calendar_object($calendar_events);
    CreateCalendarFile::save_calendar_file($ENV{KSK_CALENDAR_FILE}, $calendar_events);
}

get_ksk_events();