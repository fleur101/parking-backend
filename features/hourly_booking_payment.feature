Feature: Booking payment
    As a user
    Such that I have an hourly booking for parking location
    I want to pay for it

    Scenario: Pay for the booking
        Given I have an active booking
        When I log in to the application
        And I navigate to the payment page
        And I click "Pay for the booking"
        And I enter my credentials
        Then payment for the booking is made successfully
