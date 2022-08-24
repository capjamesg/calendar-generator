#!/usr/bin/perl

use strict;
use Mojo::DOM;
use LWP::UserAgent;
use Text::Trim qw(trim);
use DateTime::Format::Strptime;
use Dotenv -load;

use lib "./";
use CreateCalendarFile;

sub get_indieweb_events {
    my $ua = LWP::UserAgent->new;

    my $request = $ua->get("https://indieweb.org/timeline");

    my $page_dom = Mojo::DOM->new($request->content);

    my @events = $page_dom->find("#mw-content-text")->first->find("li")->each;

    my $calendar_events = "";

    my $event_count = 0;

    for my $event (@events) {
        my $event_data = trim $event->all_text();

        # print $event_data, "\n";

        if ($event_data =~ /^\d{4}-\d{2}-\d{2} (.*)$/) {
            my @split_event_data = split / /, $event_data;
            my $event_date = $split_event_data[0];

            my $event_description = join(" ", @split_event_data[2.. $#split_event_data]);
            my @sentences = split /\. /, $event_description;
            my $event_name = $sentences[0];

            my @split_date = split /-/, $event_date;
            my $month = $split_date[1];
            my $day = $split_date[2];
            
            $event_date =~ s/-//g;

            my $rule = "\nRRULE:FREQ=YEARLY;INTERVAL=1;BYMONTH=$month;BYMONTHDAY=$day";

            $calendar_events .= CreateCalendarFile::create_event($event_date, $event_date, "INDIEWEBEVENTS", $event_name, $event_description, $rule, $event_count);

            $event_count += 1;
        }
    }

    $calendar_events = CreateCalendarFile::create_calendar_object($calendar_events);
    CreateCalendarFile::save_calendar_file($ENV{INDIEWEB_CALENDAR_FILE}, $calendar_events);
}

get_indieweb_events();