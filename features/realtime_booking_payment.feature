Feature: Realtime booking payment
    As a user
    Such that I have a realtime booking for parking location
    I want to pay for it at the end of parking time

    Scenario: Pay for the booking
        Given I have an active realtime booking
        And the "monthly" setting is false for realtime payments
        And current time exceeds the end time of parking
        Then payment for my booking is recorded in stripe
        And location is made available
