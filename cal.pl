#!/usr/bin/perl

use strict;
use warnings;
use Mojo::DOM;
use LWP::UserAgent;
use Text::Trim qw(trim);
use DateTime::Format::Strptime;
use Dotenv -load;

my $ua = LWP::UserAgent->new;

my $request = $ua->get("https://developers.google.com/search/updates/ranking");

my $page_dom = Mojo::DOM->new($request->content);

my $events_table = $page_dom->at("table");

my @events = $events_table->find("tr")->each;

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
            $calendar_events .= "BEGIN:VEVENT
DTSTAMP:$date_string
DTSTART:$date_string
DTEND:$date_string
STATUS:CONFIRMED
CATEGORIES:GOOGLEUPDATES
Summary:Google Update - $date
Description:$description
END:VEVENT
"
        }
    }
}

my $calendar_heading = "BEGIN:VCALENDAR
VERSION:2.0
";

$calendar_events = $calendar_heading . $calendar_events;
$calendar_events .= "END:VCALENDAR";

open (my $fh, '>', $ENV{CALENDAR_FILE}) or die "Could not open file";
print $fh $calendar_events;
close $fh;