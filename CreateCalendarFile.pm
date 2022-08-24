#!/usr/bin/perl

package CreateCalendarFile;

use warnings;
use strict;
use LWP::UserAgent;
use Mojo::Dom;

sub get_table_from_url {
    my $ua = LWP::UserAgent->new;

    my $request = $ua->get($_[0]);

    my $page_dom = Mojo::DOM->new($request->content);

    my $events_table = $page_dom->at("table");

    my @events = $events_table->find("tr")->each;

    return @events;
}

sub create_calendar_object {
    my $calendar_heading = "BEGIN:VCALENDAR
PRODID:capjamesg/calendar-generator
VERSION:2.0
";
    my $calendar_events = $_[0];

    $calendar_events = $calendar_heading . $calendar_events;
    $calendar_events .= "END:VCALENDAR";

    return $calendar_events;
}

sub create_event {
    my $date_start = $_[0] . "T120000Z";
    my $date_end = $_[1] . "T120000Z";
    my $categories = $_[2];
    my $summary = $_[3];
    my $description = $_[4];
    my $rule = $_[5] || "";
    my $uid = $_[6];

    my $calendar_event_item = "BEGIN:VEVENT
UID:$uid
DTSTAMP:$date_start
DTSTART:$date_start
$rule
STATUS:CONFIRMED
CATEGORIES:$categories
Summary:$summary
Description:$description
END:VEVENT
";
    return $calendar_event_item;
}

sub save_calendar_file {
    open (my $fh, '>', $_[0]) or die "Could not open file";
    print $fh $_[1];
    close $fh;
}

1;