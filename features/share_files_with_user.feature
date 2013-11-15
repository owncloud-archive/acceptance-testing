# encoding: utf-8
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

  Scenario Outline: share with a user
    And I hover over <filename>
    When I click on the Share action of <filename>
    And I am sharing this <filename> to user2
    Then I should see the share with user icon within <filename>
    And I should see the username in the list of shared users within <filename>
    Given I am not logged in
    Given I am logged in as user2
    And I go into the Shared Folder
    Then I should see the shared <filename>

  Examples:
  | type   | filename                                         |
  | file   | Demo Movie OGG - Big Bug Bunny Trailer.ogg       |

  Scenario Outline: list shared files
    And I hover over <filename>
    When I click on the Share action of <filename>
    And I am sharing this <filename> to user2
    Then I should see the share with user icon within <filename>

  Examples:
  | type   | filename                                         |
  | file   | Demo Code - PHP.php                              |
  | file   | Demo Code - Python.py                            |

  Scenario: list unshared files
    #Share a file
    And I hover over Demo Movie OGG - Big Bug Bunny Trailer.ogg
    When I click on the Share action of Demo Movie OGG - Big Bug Bunny Trailer.ogg
    And I am sharing this Demo Movie OGG - Big Bug Bunny Trailer.ogg to user2
    #Check not shared file
    And I hover over Demo Image - Laser Towards Milky Ways Centre.jpg
    Then I should not see the share with user icon within Demo Image - Laser Towards Milky Ways Centre.jpg

  Scenario: share permissions
    #Share a file
    And I hover over Demo Movie OGG - Big Bug Bunny Trailer.ogg
    When I click on the Share action of Demo Movie OGG - Big Bug Bunny Trailer.ogg
    And I am sharing this Demo Movie OGG - Big Bug Bunny Trailer.ogg to user2
    And I click on the Share action of Demo Movie OGG - Big Bug Bunny Trailer.ogg
    And In the share menu i hover over user2
    Then I should see a "can edit" checkbox
    And I should see an unshare action

  Scenario Outline: unshare
    And I hover over <filename>
    When I click on the Share action of <filename>
    And I am sharing this <filename> to user2
    Then I should see the share with user icon within <filename>
    And I click on the Share action of <filename>
    And In the share menu i hover over user2
    Then I should see a "can edit" checkbox
    And I click on the unshare action
    Then I should not see the username in the list of shared users

  Examples:
  | type   | filename                                         |
  | file   | Demo Image - Northern Lights.jpg                 |

