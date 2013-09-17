# encoding: utf-8
Feature: Login
  In order to protect data in my cloud instance
  As an user
  I want restricted access to my cloud
  Scenario: Login via web browser
    Given I am not logged in
    When I enter my valid credential
    Then I should be able to access my cloud
