# encoding: utf-8
Feature: users
  In order to organize users
  As an administrator
  I want to have basic user management

  Background:
    Given I am logged in
	And I am in the "users" settings

  Scenario Outline: list users
    Then the list shows a user "<name>"
    Then user "<name>" should have the full name "<fullname>"
    Then user "<name>" should be in group "<group>"
    And I should see a create user form

    Examples:
      | name                 | fullname                                         | group    |
      | admin                | Administrator                                    | admin    |
      | user1                | User One                                         | group1   |
      | user2                | User Two                                         | group1   |
      | user3                | User Three                                       |          |

  Scenario: create a user
    Given user "newuser" does not exist
	When I fill the user form with "newuser" and "p4$$W0rD!"
	And I click create user
	Then the list shows a user "newuser"
	And no error appears

  Scenario: create a user that already exists
	Given user "user1" exists
	When I fill the user form with "user1" and "whatever"
	And I click create user
	Then an error dialog appears

  Scenario: changing user details
    Given user "newuser" exists
	When I change the full name of user "newuser" to "Full Name"
	Then user "newuser" should have the full name "Full Name" 
	And no error appears

  Scenario: setting user group
	Given user "newuser" exists
	And group "group1" exists
	When I add user "newuser" to group "group1"
    Then user "newuser" should be in group "group1"
	And no error appears

  Scenario: unsetting user group
	Given user "newuser" is in group "group1"
	When I remove user "newuser" from group "group1"
    Then user "newuser" should not be in group "group1"
	And no error appears

  Scenario: delete a user
    Given user "newuser" exists
	When I click delete for user "newuser"
	Then the list does not show a user "newuser"
	And a notification appears

