Feature: Booking payment
    As a user
    Such that Hourly bookings is being made on parking location
    I want to make payment 

    Scenario: Pay for the booking
        Given I have an active booking
        When I navigate to payment page
        And I click "Pay for the booking"
        And I enter my credentials
        Then Booking is payed successfully
