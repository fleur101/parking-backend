Feature: Updating booking and parking spot statuses
    As the booking system
    Such that Hourly bookings have been booked on parking location
    I want to update parking statuses

    Scenario: Make booked hourly space available two minutes before end time
        Given there is an available parking space
        When I log in to the application
        And I book the parking location on "hourly" rate for "1 hour"
        And I search for parking locations nearby after "58 minutes"
        Then the booked parking location appears in search results


