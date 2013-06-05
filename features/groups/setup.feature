Feature: Setup group
  As a group admin
  So I can set up my group to start using Loomio
  I want to be taken through the setup process

  Background:
    Given I am logged in


@javascript
  Scenario: Group admin sets up a group
    Given I am an admin of a group
    And I visit the group setup wizard for that group
    And I complete the group setup wizard
    Then the group should be setup
    And I should be on the group page

@javascript
  Scenario: Group admin tries to set up a group that alredy has been set up
    Given I am an admin of a group
    And the users time-zone has been set
    And a group is already setup
    When I visit the group setup wizard for that group
    Then I should be redirected to the group page

@javascript
  Scenario: Non group admin tries to set up a group
    Given I am a member of a group
    When I visit the group setup wizard for that group
    Then I should be told that I dont have permission to set up this group

