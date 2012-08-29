Feature: files
  In order to organize my files
  As a user
  I want to use basic file management

  Scenario: list files
    Given I am logged in
    And I have uploaded some files
    When I go to the files app
    Then I should see a list of my files
    And I should see a new button
    And I should see an upload action
    And for every file in the list I should see the size
    And for every file in the list I should see the last modified date
    
  Scenario: show file actions on hover
    Given I am logged in
    And I am in the files app
    And I have uploaded some files
    When I hover over a file
    Then I should see a rename action
    And I should see a download action
    And I should see a delete action

  Scenario: create file
    Given I am logged in
    And I am in the files app
    When I click on the new button
    And I click on the new file action
    And I enter a name
    Then I should see the new file
    And I should see an icon for the new file
    And I should see the size of the new file

  Scenario: create folder
    Given I am logged in
    And I am in the files app
    When I click on the new button
    And I click on the new folder action
    And I enter a name
    Then I should see the new folder with the name I entered
    And I should see a folder icon for the new folder
    And I should see a size of 0 for the new folder
    
  Scenario: create from URL
    Given I am logged in
    And I am in the files app
    When I click on the new button
    And I click on the from URL action
    And I enter a URL
    Then I should see the downloaded file with the basename of the URL as the name
    And I should see an icon for the new file
    And I should see the size of the new file

  Scenario: upload file
    Given I am logged in
    And I am in the files app
    When I click on the upload action
    And I choose a file to upload in the dialog
    Then I should see the new file

  Scenario: rename file
    Given I am logged in
    And I have uploaded some files
    And I am in the files app
    When I hover over a file
    And I click on the rename link of it
    And I enter a name
    Then I should see the new filename
    Then I should not see the old filename
    
  Scenario: download file
    Given I am logged in
    And I have uploaded some files
    And I am in the files app
    When I hover over a file
    And I click on the download link of it
    Then I should download the file

  Scenario: delete file
    Given I am logged in
    And I have uploaded some files
    And I am in the files app
    When I hover over a file
    And I click on the delete link of it
    Then I should no longer see the file