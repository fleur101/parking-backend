Feature: Updating booking and parking spot statuses
    As the booking system
    Such that Hourly bookings have been booked on parking location
    I want to update parking statuses

    Scenario: Make booked hourly space available two minutes before end time
        When I log in to the application
        And I book the parking location on hourly rate
        Then Parking location does not appear in search results
        Then I search for booked parking location 1 minute before booking end time
        And Parking location appears in search results
