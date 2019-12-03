Feature: Monthly payments of realtime bookings
    As a customer
    Such that I have logged in to the application
    I want to pay for realtime bookings at the end of the month

    Scenario: List bookings
        When I log in to the application
        And The monthly payment setting is true for realtime payments
        And Today is 1st of a month
        Then Display modal to pay for all pending realtime bookings
        And If there are realtime bookings pending in the last month, display pay button
        Then User clicks on pay button
        And payment is recorded for all pending bookings
