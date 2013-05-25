Feature: translate emails
  As a member of a group
  So that I can participate fully
  Emails should be delivered in my prefered language

  Scenario: Spanish-speaking group member recieves new discussion email in Spanish
    Given I am logged in
    And I am a member of a group
    And "Jesse" is a Spanish-speaking member of the group
    And no emails have been sent
    When I visit the group page
    And I choose to create a discussion
    And I fill in the discussion details and submit the form
    Then "jesse@example.org" should receive an email
    When they open the email
    Then they should see "Grupo" in the email body

  Scenario: group member with unspecified language preference receives new discussion email in discussion author's language
    Given I am logged in
    And I am a member of a group
    And "Jesse" is a member of the group
    And no emails have been sent
    And my language preference is set to "es"
    And I visit the group page
    And I choose to create a discussion
    And I fill in the discussion details and submit the form
    Then "jesse@example.org" should receive an email
    When they open the email
    Then they should see "Grupo" in the email body

  Scenario: Spanish-speaking group member recieves new proposal email in Spanish
    Given I am logged in
    And I am an admin of a group with a discussion
    And "Jesse" is a Spanish-speaking member of the group
    And no emails have been sent
    When I visit the discussion page
    And I click the element "#new-proposal"
    And fill in the proposal details and submit the form
    Then "jesse@example.org" should receive an email
    When they open the email
    Then they should see "Grupo" in the email body

  Scenario: group member with unspecified language preference receives new proposal email in proposal author's language
    Given I am logged in
    And I am an admin of a group with a discussion
    And "Jesse" is a member of the group
    And no emails have been sent
    And my language preference is set to "es"
    And I visit the discussion page
    And I click the element "#new-proposal"
    And fill in the proposal details and submit the form
    Then "jesse@example.org" should receive an email
    When they open the email
    Then they should see "Grupo" in the email body

  Scenario: English-speaking user requests to join group with Spanish-speaking admin
    Given I am logged in
    And a public group exists with a Spanish-speaking admin "eduardo"
    When I visit the group page
    And no emails have been sent
    When I click the element "#request-membership"
    Then "eduardo@example.org" should receive an email
    When they open the email
    Then they should see some Spanish text in the email body

  Scenario: Spanish-speaking user receives proposal closed email in Spanish
    Given I am logged in
    And I am an admin of a group
    And "Jesse" is a Spanish-speaking member of the group
    And there is a discussion in the group
    And the discussion has an open proposal
    And "Jesse" is the author of the proposal
    And no emails have been sent
    When I visit the discussion page
    And I click the 'Close proposal' button
    And I confirm the action
    Then "jesse@example.org" should receive an email
    When they open the email
    Then they should see some Spanish text in the email body

  Scenario: Spanish-speaking user receives proposal blocked email in Spanish
    Given I am logged in
    And there is a discussion in a group I belong to
    And "Jesse" is a Spanish-speaking member of the group
    And the discussion has an open proposal
    And "Jesse" is the author of the proposal
    And no emails have been sent
    When I visit the discussion page
    And I click the 'block' vote button
    And I enter a statement for my block
    Then "jesse@example.org" should receive an email
    When they open the email
    Then they should see "Grupo" in the email body

  Scenario: Ben is sent a daily activity email
    Given there is a user "Ben"
    And there is a user "Hannah"
    And "Ben" is subscribed to daily activity emails
    And "Hannah" is subscribed to daily activity emails
    And "Ben"s language preference is set to "es"
    And "Hannah"s language preference is set to "en"
    Given there is a group "Pals"
    And "Ben" belongs to "Pals"
    And "Hannah" belongs to "Pals"
    And there is a discussion "I'm Lonely" in "Pals"
    And no emails have been sent
    When we send the daily activity email
    Then "hannah@example.org" should receive an email
    When they open the email
    Then they should see "Discussions" in the email body
    Then "ben@example.org" should receive an email
    When they open the email
    Then they should see some Spanish text in the email body
