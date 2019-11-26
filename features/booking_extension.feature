Feature: Sending notification to frontend for extending time
    As a user
    Such that Hourly booking has been booked on parking location and payment has been already made by me
    I want to extend parking time

    Scenario: Extending booking time
        Given I received notification for extending booking time
        When I click on the notification
        And I enter new end time
        And I pay for the additional cost incurred (cost for time period (new_end_time - start_time) - (old_end_time - start_time))
        Then The time for parking space is extended
