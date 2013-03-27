Feature: Loomio admin approves group request to join Loomio
  As a Loomio super-admin
  So that I can moderate the growth of the Loomio userbase
  I want to be able to approve group applications

  Background:
    Given I am a Loomio super-admin
    And I am logged in
    And there is a verified request to join Loomio

  Scenario: Loomio admin approves a group request
    When I visit the Group Requests page on the admin panel
    And I click approve for a request
    And I should see the send approval email page
    And I customise the approval email text
    And I click the send and approve button
    Then the group request should be marked as approved
    And the group should be created
    And an email should be sent to the group admin containing a link to start the new group
    And I should be redirected to the Group Requests page
    And I should no longer see the request

  Scenario: Loomio admin sets the maximum group size
    When I visit the Group Requests page on the admin panel
    And I edit the maximum group size
    And I click approve for a request
    And I click the send and approve button
    Then the maximum group size should be assigned to the group

  Scenario: Loomio admin defers a group request
    When I visit the Group Requests page on the admin panel
    And I click defer for the request
    And I should see the send defer email page
    And I select the date to defer until
    And I click the send and defer button
    Then the group request should be marked as defered
    And I should be redirected to the Group Requests page
    And I should no longer see the request
