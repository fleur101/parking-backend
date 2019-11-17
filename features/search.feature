Feature: Search for available parking spaces
    As a customer 
    Such that I want to park my car near destination place
    I want to find an available parking spaces nearby

    Scenario: Find available parking spaces
        When I open search page
        And I enter destination place "Kaubamaja"
        And I submit the form
        Then I see a summary of available parkings space

    Scenario: Calculate fee to be paid
        When I open search page
        And I enter destination place "Kaubamaja"
        And I enter the intended leaving hour
        And I submit the form
        Then I see an estimation of fee to be paid
