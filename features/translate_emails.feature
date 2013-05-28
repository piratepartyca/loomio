Feature: deliver emails in the user's prefered language
  As a member of a group
  So that I can participate fully
  Emails should be delivered in my prefered language

  Background:
    Given "John" is a user with an English language preference
    And "Eduardo" is a user with a Spanish language preference
    And "Viv" is a user without a specified language preference

  Scenario: new discussion email
    Given "John" has created a new discussion
    Then the new discussion email should be delivered to "Eduardo" in Spanish
    And the new discussion email should be delivered to "Viv" in English

  Scenario: new proposal email
    Given "Eduardo" has created a new proposal
    Then the new proposal email should be delivered to "Viv" in Spanish
    And the new proposal email should be delivered to "John" in English

  Scenario: proposal blocked email
    Given "John" has blocked a proposal started by "Eduardo"
    Then the proposal blocked email should be delivered to "Eduardo" in Spanish

  Scenario: proposal closed email
    Given "Eduardo" has closed their proposal
    Then the proposal closed email should be delivered to "Viv" in Spanish
    And the proposal closed email should be delivered to "John" in English

  Scenario: membership request email
    When "John" requests membership to the group
    Then the membership request email should be delivered to "Eduardo" in Spanish
    Then the membership request email should be delivered to "Viv" in English

  Scenario: daily activity email
    When the daily activity email is sent
    Then "Eduardo" should receive the daily activity email in Spanish
