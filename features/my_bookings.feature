Feature: Booking a parking space
    As a customer
    Such that I have logged in to the application
    I want to see the bookings I made

    Scenario: List bookings
        When I log in to the application
        And I click on My Bookings tab
        Then I see list of all bookings I have made
        And I do not see Pay button for bookings for which I have already paid
        And I do not see Pay button for real time bookings which are still active
        And I do not see Pay button for real time bookings which have ended and I have not paid for them if monthly setting is on
        And I see Pay button for real time bookings which have ended and I have not paid for them if monthly setting is off
        And I see Pay button for hourly bookings for which payment is pending
