@d8 @d9
Feature: Check that UserTrait works for D8 or D9

  Background:
    Given users:
      | name                        | mail                                      | roles         | status |
      | administrator_user          | administrator_user@myexample.com          | administrator | 1      |
      | authenticated_user          | authenticated_user@myexample.com          |               | 1      |
      | authenticated_user_disabled | authenticated_user_disabled@myexample.com |               | 0      |

  @api
  Scenario: Assert "When I visit user :name profile"
    Given I am logged in as a user with the "administrator" role
    When I visit user "authenticated_user" profile
    Then I should get a 200 HTTP response

  @api
  Scenario: Assert "Given no users:" by name
    Given I am logged in as a user with the "administrator" role
    When I visit user "authenticated_user" profile
    Then I should get a 200 HTTP response

    When no users:
      | name               |
      | authenticated_user |

    Then user "authenticated_user" does not exists

  @api
  Scenario: Assert "Given no users:" by email
    Given I am logged in as a user with the "administrator" role
    When I visit user "authenticated_user" profile
    Then I should get a 200 HTTP response

    When no users:
      | mail                             |
      | authenticated_user@myexample.com |

    Then user "authenticated_user" does not exists

  @api
  Scenario: Assert "Then user :name has :roles role(s) assigned"
    Given user "authenticated_user" has "authenticated" role assigned
    And user "authenticated_user" has "authenticated" roles assigned

    Given user "administrator_user" has "authenticated, administrator" roles assigned

  @api
  Scenario: Assert "Then user :name does not have :roles role(s) assigned"
    Given user "authenticated_user" does not have "administrator" role assigned
    And user "authenticated_user" does not have "administrator" roles assigned

  @api
  Scenario: Assert "Then user :name has :status status"
    Given user "authenticated_user" has "active" status

    Given user "authenticated_user_disabled" has "not active" status
    And user "authenticated_user_disabled" has "disabled" status

  @api
  Scenario: Assert "Then user :name has :status status"
    Given I set user "administrator_user" password to "password123"
    Given I set user "administrator_user@myexample.com" password to "password123"

  @trait:UserTrait @api
  Scenario: Assert that negative assertions fail with an error
    Given some behat configuration
    And scenario steps:
      """
      Given I set user "non_existing_user" password to "password123"
      """
    When I run "behat --no-colors"
    Then it should fail with an error:
      """
      Unable to find a user with name or email "non_existing_user".
      """
