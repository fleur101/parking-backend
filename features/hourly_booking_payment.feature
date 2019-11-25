Feature: Sending notification to frontend for extending time
    As the booking system
    Such that Hourly bookings is being made on parking location
    I want to make payment before booking is made

    Scenario: Make booked hourly space available two minutes before end time
        When I log in to the application
        And I book the parking location on hourly rate
        And I make the payment for the booking
        Then I create the booking
        And I see page to enter my debit/credit card details
        Then I enter my debit/credit card details
        And Booking is made successfully
