Feature: Booking a parking space
    As a customer
    Such that I have arrived at my desired destination
    I want to book a nearby parking place

    Scenario: Book a nearby parking place for hourly rate
        When I log in to the application
        And I visit the booking page
        And I enter Payment Type "Hourly"
        And I enter Start Time "13:00"
        And I enter End Time "14:00"
        And I submit the booking request
        And I book the nearest available parking location
        And I search for parking locations nearby
        Then the booked location does not appear in any search results

    Scenario: Book a nearby parking place for realtime rate
        When I log in to the application
        And I visit the booking page
        And I enter Payment Type "Realtime"
        And I enter Start Time "13:00"
        And I enter End Time "14:00"
        And I submit the booking request
        And I book the nearest available parking location
        And I search for parking locations nearby
        Then the booked location does not appear in any search results

    Scenario: Booking a nearby parking place when no places are available
        When I log in to the application
        And I visit the booking page
        And I enter Payment Type "Realtime"
        And I enter Start Time "13:00"
        And I enter End Time "14:00"
        And I submit the booking request
        And I search for parking locations nearby
        Then I receive notification "Currently, there are no available spaces present, please try again later"
