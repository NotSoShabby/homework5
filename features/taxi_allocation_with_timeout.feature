Feature: Taxi allocation with timeout
  As an automated system (STRS)
  Such that our customers can be picked up in a short term
  I want to select the taxi that is closest to the pick up address
            and retry with another taxi if the first one does not respond
  Scenario Outline: Booking via mobile phone
    Given the following taxis are on duty
          | username | location	   |
          | taxi1    | Vanemuise 4 |
          | taxi2    | Vaksali 6   |
          | taxi3    | Umera 1     |
    And the status of the taxis is "<statuses>"
    And I want to go from "<pickup_address>" to "<dropoff_address>"
    And I enter the booking information on the STRS Customer app
    When I summit the booking request
    And "<choice1>" is contacted
    And "<choice1>" decides to "<action1>"
    And "<choice2>" is contacted
    And "<choice2>" decides to "<action2>"
    Then I should be notified "<notification>"

    Examples:
        | statuses                 | pickup_address   | dropoff_address | choice1 | action1 | choice2 | action2 | notification       |
        | available,busy,available | Liivi 2          | Riia 132        | taxi1   | timeout | taxi3   | reject  | no taxi available  |
        | busy,available,availabe  | Raatuse 22       | Kreutzwaldi 1   | taxi2   | timeout | taxi3   | accept  | taxi arriving soon |
        | available,available,busy | Tamme puiestee 1 | Turu 10         | taxi2   | reject  | taxi1   | accept  | taxi arriving soon |