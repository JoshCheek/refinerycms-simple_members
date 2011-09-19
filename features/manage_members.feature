@members
Feature: Members
  In order to have members on my website
  As an administrator
  I want to manage members

  Background:
    Given I am a logged in refinery user
    And I have no members

  @members-list @list
  Scenario: Members List
   Given I have members titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of members
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @members-valid @valid
  Scenario: Create Valid Member
    When I go to the list of members
    And I follow "Add New Member"
    And I fill in "First Name" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 member

  @members-invalid @invalid
  Scenario: Create Invalid Member (without first_name)
    When I go to the list of members
    And I follow "Add New Member"
    And I press "Save"
    Then I should see "First Name can't be blank"
    And I should have 0 members

  @members-edit @edit
  Scenario: Edit Existing Member
    Given I have members titled "A first_name"
    When I go to the list of members
    And I follow "Edit this member" within ".actions"
    Then I fill in "First Name" with "A different first_name"
    And I press "Save"
    Then I should see "'A different first_name' was successfully updated."
    And I should be on the list of members
    And I should not see "A first_name"

  @members-duplicate @duplicate
  Scenario: Create Duplicate Member
    Given I only have members titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of members
    And I follow "Add New Member"
    And I fill in "First Name" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 members

  @members-delete @delete
  Scenario: Delete Member
    Given I only have members titled UniqueTitleOne
    When I go to the list of members
    And I follow "Remove this member forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 members
 