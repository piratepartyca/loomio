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
    Then they should see Spanish text in the email body

