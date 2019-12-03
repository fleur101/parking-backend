Feature: Realtime booking payment
    As a system
    Such that Realtime bookings is being made on parking location
    I want to charge user at the end of parking time

    Scenario: Pay for the booking
        Given I have an active realtime booking
        And Monthly setting of my user is false for realtime payments
        And Time Exceeds end time of parking
        Then Payment for my booking is recorded in stripe
        And Location is made available
