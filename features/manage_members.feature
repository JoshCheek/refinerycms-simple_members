@members
Feature: Members
  In order to have members on my website
  As an administrator
  I want to manage members

  Background:
    # Given I am a logged in refinery user
    And I have no members

  Scenario: Create members
    Then I can create these members
      | first_name | last_name | email            | unique_identifier |
      | Clara      | Jones     | cjones@gmail.com | A3X9              |
      | Greg       | Watson    | gw49@hotmail.com | B932              |
      |            |           |                  | C93P              |

  Scenario: Unique number is mandatory
    Then I cannot create these members
      | first_name | last_name | email            | unique_identifier |
      | Clara      | Jones     | cjones@gmail.com |                   |

  Scenario: Number must be unique
    Then I can create these members
      | first_name | last_name | email                 | unique_identifier |
      | Abe        | Lincoln   | potus@whitelhouse.gov | AAAA              |
    Then I cannot create these members
      | first_name | last_name | email             | unique_identifier |
      | Jim        | Beam      | yay@happytime.com | AAAA              |


