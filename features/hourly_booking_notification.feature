Feature: Sending notification to frontend for extending time
    As the booking system
    Such that Hourly bookings have been booked on parking location and payment has been already made
    I want to send notification 10 minutes before the ending time

    Scenario: Make booked hourly space available two minutes before end time
        When I log in to the application
        And I book the parking location on hourly rate
        And I make the payment for the booking
        Then 10 minutes prior to end time I should receive a notification to extend my parking time
