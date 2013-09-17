#Feature: share files with user
#  In order to collaborate with other owncloud users
#  As a user
#  I want to share files with other users
#
#  Scenario: share dialog
#    Given I am logged in
#    And I have uploaded some files
#    When I go to the files app
#    And I hover over a file
#    And I click on the share file action
#    Then I should see a share with text input
#
#  Scenario: share with a user
#    Given I am logged in
#    And I have uploaded some files
#    When I go to the files app
#    And I hover over a file
#    And I click on the share file action
#    And I enter a user name
#    And I click the username
#    And I hover over the file
#    Then I should see the share with user icon
#    And I should see the username in the list of shared users
#
#  Scenario: list shared files
#    Given I am logged in
#    And I have shared some files
#    When I go to the files app
#    And I hover over a file shared with a user
#    Then I should see the share with user icon
#
#  Scenario: list unshared files
#    Given I am logged in
#    And I have shared some files
#    When I go to the files app
#    And I hover over a file not shared with a user
#    Then I should not see the share with user icon
#
#  Scenario: share permissions
#    Given I am logged in
#    And I have shared a file
#    When I go to the files app
#    And I hover over the file
#    And I click on the share file action
#    And I hover over the user I shared the file with
#    Then I should see a "can edit" checkbox
#    And I should see an unshare action
#
#  Scenario: unshare
#    Given I am logged in
#    And I have shared a file
#    When I go to the files app
#    And I hover over the file
#    And I click on the share file action
#    And I hover over the user I shared the file with
#    And I click on the unshare action
#    Then I should not see the username in the list of shared users
#
#