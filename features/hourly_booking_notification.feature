Feature: Receiving notification for extending time
    As a user
    Such that I have an hourly booking for a parking location and I have already paid for it
    I want to receive notification 10 minutes before the end time

    Scenario: Receiving notification for extending time
        When I log in to the application
        And I book the parking location on hourly rate
        And I make the payment for the booking
        Then 10 minutes prior to end time I should receive a notification to extend my parking time
