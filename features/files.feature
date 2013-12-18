# encoding: utf-8
Feature: files
  In order to organize my files
  As a user
  I want to have basic file management

  Background:
    Given I am logged in
    # these are the files hosted on demo.owncloud.org
    And I am in the "files" app
    And I have uploaded the "demo" files
    # TODO create directories (there is a branch create_directories_feature)

  Scenario Outline: list files
#    When I go to "/"
    Then <name> should be of type <mime>
    Then <name> should have <bytes> bytes size
    And <name> should show a <human> size
    And I should see a new button
    And I should see an upload action

    Examples:
      | mime                 | name                                             | bytes    | human    |
      | text/x-c             | Demo Code - C++.cc                               | 3066     | 3 kB     |
      | application/x-php    | Demo Code - PHP.php                              | 3705     | 3.6 kB   |
      | text/x-script.python | Demo Code - Python.py                            | 875      | 875 B    |
      | image/jpeg           | Demo Image - ccc.jpg                             | 166367   | 162.5 kB |
      | image/jpeg           | Demo Image - Laser Towards Milky Ways Centre.jpg | 315057   | 307.7 kB |
      | image/jpeg           | Demo Image - Northern Lights.jpg                 | 224246   | 219 kB   |
      | video/quicktime      | Demo Movie MOV - Big Bug Bunny Trailer.mov       | 11061011 | 10.5 MB  |
      | audio/ogg            | Demo Movie OGG - Big Bug Bunny Trailer.ogg       | 4360399  | 4.2 MB   |
      | audio/mpeg           | Demo MP3 - E.J. - Blick Zurück.mp3               | 2998100  | 2.9 MB   |
      | application/pdf      | Demo PDF - Alice in Wonderland.pdf               | 711671   | 695 kB   |
      | text/plain           | Demo Textfile - License.txt                      | 2016     | 2 kB     |
      #Can be tested as soon as we can create the folders
      #| httpd/unix-directory | Music                                            | 73705595 | 70.3 MB  |
      #| httpd/unix-directory | Photos                                           | 784677   | 766.3 kB |
    
  Scenario Outline: show file actions on hover
#    And I go to /
    When I hover over <filename>
    Then I should see a "Rename" action for <filename>
    And I should see a "Download" action for <filename>
    And I should see a delete action for <filename>
    
    Examples:
      | filename                                         |
      | Demo Code - C++.cc                               |
      | Demo Code - PHP.php                              |
      | Demo Code - Python.py                            |
      | Demo Image - ccc.jpg                             |
      | Demo Image - Laser Towards Milky Ways Centre.jpg |
      | Demo Image - Northern Lights.jpg                 |
      | Demo Movie MOV - Big Bug Bunny Trailer.mov       |
      | Demo Movie OGG - Big Bug Bunny Trailer.ogg       |
      | Demo MP3 - E.J. - Blick Zurück.mp3               |
      | Demo PDF - Alice in Wonderland.pdf               |
      | Demo Textfile - License.txt                      |
      #Can be tested as soon as we can create the folders
      #| Music                                           |
      #| Photos                                          |

  Scenario Outline: create files and folders
    When I click on the new button
    And I click on the new <type> action
    And I enter the filename <name>
    Then I should see the file <name>
    And <name> should be of type <mime>
    And <name> should have <bytes> bytes size

    Examples:
      | type   | mime              | name               | bytes |
      | file   | text/plain        | simplefile.txt     | 0     |
      | file   | text/plain        | äöü ß ÄÖÜ € @.txt  | 0     |
      | file   | application/x-php | test.php           | 0     |
      #TODO test.cc gives empty mimetype. Need more info
      #| file   | text/x-c          | test.cc            | 0     |
      #Can be tested as soon as we can create the folders
      #| folder | httpd/unix-directory | Testfolder             | 0    |
      #| folder | httpd/unix-directory | Testfolder with spaces | 0    |

  Scenario Outline: download file
    And I go to /
    When I hover over <filename>
    And I click on the Download action of <filename>
    # TODO have not found better escape function
    Then I should download <filename>

    Examples:
      | filename                                         | file_escaped                                     |
      #TODO Fails because of "++" encoding??
      #| Demo Code - C++.cc                               | Demo%20Code%20-%20C%2B%2B.cc                     |
      | Demo Code - PHP.php                              | Demo%20Code%20-%20PHP.php                        |
      | Demo Code - Python.py                            | Demo%20Code%20-%20Python.py                      |
#      | Demo Image - ccc.jpg                             | Demo%20Image%20-%20ccc.jpg                       |
#      | Demo Image - Laser Towards Milky Ways Centre.jpg | Demo Image - Laser Towards Milky Ways Centre.jpg |
#      | Demo Image - Northern Lights.jpg                 | Demo Image - Northern Lights.jpg                 |
#      | Demo Movie MOV - Big Bug Bunny Trailer.mov       | Demo Movie MOV - Big Bug Bunny Trailer.mov       |
#      | Demo Movie OGG - Big Bug Bunny Trailer.ogg       | Demo Movie OGG - Big Bug Bunny Trailer.ogg       |
#      | Demo MP3 - E.J. - Blick Zurück.mp3               | Demo MP3 - E.J. - Blick Zurück.mp3               |
#      | Demo PDF - Alice in Wonderland.pdf               | Demo PDF - Alice in Wonderland.pdf               |
#      | Demo Textfile - License.txt                      | Demo Textfile - License.txt                      |
      #Can be tested as soon as we can create the folders
      #| Music                                            | Music.zip                                        |
      #| Photos                                           | Photos.zip                                       |

  Scenario Outline: delete item
    And I go to /
    When I hover over <filename>
    And Click the delete cross of <filename>
    Then I should no longer see <filename>

    Examples:
      | type   | filename                                         |
      | file   | Demo Code - C++.cc                               |
      | file   | Demo Code - PHP.php                              |
      | file   | Demo Code - Python.py                            |
      | file   | Demo Image - ccc.jpg                             |
      | file   | Demo Image - Laser Towards Milky Ways Centre.jpg |
      | file   | Demo Image - Northern Lights.jpg                 |
      | file   | Demo Movie MOV - Big Bug Bunny Trailer.mov       |
      | file   | Demo Movie OGG - Big Bug Bunny Trailer.ogg       |
      | file   | Demo MP3 - E.J. - Blick Zurück.mp3               |
      | file   | Demo PDF - Alice in Wonderland.pdf               |
      | file   | Demo Textfile - License.txt                      |
      #Can be tested as soon as we can create the folders
      #| folder | Music                                            |
      #| folder | Photos                                           |

#  Scenario Outline: upload file
#    Given I go to /
#    When I click on the upload action
#    And I choose <type> <filename> to upload in the dialog
#    Then I should see <filename>
#    And <filename> should have a <mimetype> icon
#    And <filename> should have size <size>
#    And <filename> should have human readable size <hsize>
#
#    Examples:
#      | type   | mimetype             | filename                                         | size     | hsize    |
#      | file   | text/x-c             | Demo Code - C++.cc                               | 3066     | 3 kB     |
#      | file   | text/x-php           | Demo Code - PHP.php                              | 3705     | 3.6 kB   |
#      | file   | text/x-script.python | Demo Code - Python.py                            | 875      | 875 B    |
#      | file   | image/jpeg           | Demo Image - ccc.jpg                             | 166367   | 162.5 kB |
#      | file   | image/jpeg           | Demo Image - Laser Towards Milky Ways Centre.jpg | 315057   | 307.7 kB |
#      | file   | image/jpeg           | Demo Image - Northern Lights.jpg                 | 224246   | 219 kB   |
#      | file   | video/quicktime      | Demo Movie MOV - Big Bug Bunny Trailer.mov       | 11061011 | 10.5 MB  |
#      | file   | application/ogg      | Demo Movie OGG - Big Bug Bunny Trailer.ogg       | 4360399  | 4.2 MB   |
#      | file   | audio/mpeg           | Demo MP3 - E.J. - Blick Zurück.mp3               | 2998100  | 2.9 MB   |
#      | file   | application/pdf      | Demo PDF - Alice in Wonderland.pdf               | 711671   | 695 kB   |
#      | file   | text/plain           | Demo Textfile - License.txt                      | 2016     | 2 kB     |
#      #Can be tested as soon as we can create the folders
#      #| folder | httpd/unix-directory | Music                                            | 73705595 | 70.3 MB  |
#      #| folder | httpd/unix-directory | Photos                                           | 784677   | 766.3 kB |
#

Scenario Outline: rename file
    And I go to /
    When I hover over <oldfile>
    And I click on the "Rename" action of <oldfile>
    And I type in <newfile>
    Then There should be <newfile>
    And Not anymore the file <oldfile>

    Examples:
      | oldfile                                          | newfile                                          |
      #Can be tested as soon as we can create the folders
      #| Music                                            | Rock                                             |
      #| Photos                                           | Images                                           |
      | Demo Code - C++.cc                               | 1337 Code - C++.cc                               |
      | Demo Code - PHP.php                              | Learn to Code - PHP.php                          |
#      | Demo Code - Python.py                            | Snake Code - Python.py                           |
#      | Demo Image - ccc.jpg                             | Camp Image - ccc.jpg                             |
#      | Demo Image - Laser Towards Milky Ways Centre.jpg | Trek Image - Laser Towards Milky Ways Centre.jpg |
#      | Demo Image - Northern Lights.jpg                 | Shiny Image - Northern Lights.jpg                |
#      | Demo Movie MOV - Big Bug Bunny Trailer.mov       | Bad Movie MOV - Big Bug Bunny Trailer.mov        |
#      | Demo Movie OGG - Big Bug Bunny Trailer.ogg       | Good Movie OGG - Big Bug Bunny Trailer.ogg       |
#      | Demo MP3 - E.J. - Blick Zurück.mp3               | TOHEAR MP3 - E.J. - Blick Zurück.mp3             |
#      | Demo PDF - Alice in Wonderland.pdf               | Send PDF - Alice in Wonderland.pdf               |
#      | Demo Textfile - License.txt                      | Law Textfile - License.txt                       |

# Has not prio right know...
#  Scenario: create from URL
#    When I click on the new button
#    And I click on the from URL action
#    #TODO which url? an rfc doc? or a demo file alredy shared from demo? or from the local installation
#    And I enter a URL
#    Then I should see the downloaded file with the basename of the URL as the name
#    And I should see an icon for the new file
#    And I should see the size of the new file

# Is this test needed anymore, done with secenario "create files and folders"?
#Scenario Outline: create file and reload
#  When I click on the new button
#  And I click on the new <type> action
#  And I enter <filename>
# # file names are only fetched after reloading the page, so go to /
#  And I go to /
#  Then I should see <filename>
#  And <filename> should have a <mimetype> icon
#  And <filename> should have size <size>
#
#  Examples:
#    | type   | mimetype             | filename               | size |
#   | file   | text/plain           | simplefile.txt         | 0    |
#    | file   | text/plain           | äöü ß ÄÖÜ € @.txt      | 0    |
#    | file   | text/x-c             | test.cc                | 0    |
#    | file   | text/x-php           | test.php               | 0    |
#    #Can be tested as soon as we can create the folders
#    #| folder | httpd/unix-directory | Testfolder             | 0    |
##| folder | httpd/unix-directory | Testfolder with spaces | 0    |
