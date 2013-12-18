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

  Scenario Outline: create a user
	When I fill the user form with "<name>" and "<password>"
	And I click create user
	Then the list shows a user "<name>"
	And no error appears

    Examples:
      | name                | password   |
      | newuser             | test1234   |
	  | anothernewuser      | p4$$W0rD!  |

