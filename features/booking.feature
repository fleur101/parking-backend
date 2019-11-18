Feature: Booking a parking space
    As a customer
    Such that I have arrived at my desired destination
    I want to book a nearby parking place

    Scenario: Book a nearby parking place for hourly rate
        When I log in to the application
        And I visit the booking page
        Then I enter Payment Type "Hourly"
        And I enter Starting Time
        And I enter Ending Time
        And I submit the booking request
        And I book the nearest available parking location
        And The booked location does not appear in any search results

    Scenario: Book a nearby parking place for realtime rate
        When I log in to the application
        And I visit the booking page
        Then I enter Payment Type "Realtime"
        And I enter Starting Time
        And I enter Ending Time
        And I submit the booking request
        And I book the nearest available parking location
        And The booked location does not appear in any search results

    Scenario: Booking a nearby parking place when no places are available
        When I log in to the application
        And I visit the booking page
        Then I enter Payment Type "Realtime"
        And I enter Starting Time
        And I enter Ending Time
        And I submit the booking request
        And I receive notification "Currently, there are no available spaces present, please try again later"
