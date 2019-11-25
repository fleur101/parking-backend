Feature: Sending notification to frontend for extending time
    As a user
    Such that Hourly booking has been booked on parking location and payment has been already made by me
    I want to extend parking time

    Scenario: Make booked hourly space available two minutes before end time
        When I log in to the application
        And I book the parking location on hourly rate
        And I make the payment for the booking
        Then 10 minutes prior to end time I should receive a notification to extend my parking time
        Then I click on the notification
        And I see the page to extend my booking
        Then I enter new end time
        And Then I pay for the additional cost incurred (cost for time period (new_end_time - start_time) - (old_end_time - start_time))
        Then The time for parking space is extended
