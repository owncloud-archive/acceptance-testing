Feature: share files with link
  In order to collaborate with others
  As a user
  I want to share files with a link

  Scenario: share dialog
    Given I am logged in
    And I have uploaded some files
    When I go to the files app
    And I hover over a file
    And I click on the share file action
    Then I should see a "Share with link" checkbox
    
  Scenario: share with link
    Given I am logged in
    And I have uploaded some files
    When I go to the files app
    And I hover over a file
    And I click on the share file action
    And I click the "share with link" action
    Then I should see the share with link icon
    And I should see a URL to the file in the share with link text input

  Scenario: list shared files
    Given I am logged in
    And I have shared some files
    When I go to the files app
    And I hover over a file shared with a link
    Then I should see the share with link icon
    
  Scenario: list unshared files
    Given I am logged in
    And I have shared some files
    When I go to the files app
    And I hover over a file not shared with a link
    Then I should not see the share with link icon
    
  Scenario: unshare
    Given I am logged in
    And I have shared a file with link
    When I go to the files app
    And I hover over the file
    And I click on the share file action
    And I deselect the "share with link" action
    Then I should not see a URL to the file
    And I chould not see share with link text input  
    
    