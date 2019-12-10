Feature: Monthly payments for realtime bookings
    As a user
    Such that I have a realtime booking for parking location
    I want to pay for it at the end of the month

    Scenario: Pay for pending realtime bookings
        Given the "monthly" payment setting is true for realtime payments
        And today is the 1st day of "December"
        When I log in to the application
        And I click on "My bookings" tab
        Then I see a modal display to pay for all pending realtime bookings
        And pay button displayed for realtime bookings pending in "November"
        When I click on "Pay" button
        Then payment is recorded for all pending bookings
