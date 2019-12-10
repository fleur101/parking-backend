Feature: Updating booking and parking spot statuses
    As a user
    Such that I have an hourly booking for a parking location
    I want the parking status for my booking to be updated two minutes before the parking end time

    Scenario: Make booked hourly space available two minutes before the end time
        Given there is an available parking space
        When I log in to the application
        And I book the parking location on "hourly" rate for "1 hour"
        And I search for parking locations nearby after "58 minutes"
        Then the booked parking location appears in search results


