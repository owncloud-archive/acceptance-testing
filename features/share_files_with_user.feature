Feature: share files with user
  In order to collaborate with other owncloud users
  As a user
  I want to share files with other users

  Background:
    Given I am logged in
  # these are the files hosted on demo.owncloud.org
    And I am in the "files" app
    And I have uploaded the "demo" files

  Scenario Outline: share dialog
    And I hover over <filename>
    When I click on the Share action of <filename>
    Then I should see a share with text input

  Examples:
      | type   | filename                                         |
      | file   | Demo Code - PHP.php                              |
      | file   | Demo Code - Python.py                            |

  Scenario: share with a user
    And I am sharing this file to user1
    And I hover over Demo Movie OGG - Big Bug Bunny Trailer.ogg
    Then I should see the share with user icon
    And I should see the username in the list of shared users

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