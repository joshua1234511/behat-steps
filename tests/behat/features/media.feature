@d8 @d9
Feature: Check that MediaTrait works for D8 or D9

  @api
  Scenario: Assert "When I attach the file :file to :field_name media field"
    Given managed file:
      | path                 |
      | example_document.pdf |

    And "image" media:
      | name             | field_media_image |
      | Test media image | example_image.png |
    And "document" media:
      | name                | field_media_document |
      | Test media document | example_document.pdf |

    And I am logged in as a user with the "administrator" role
    When I visit "/admin/content/media"
    Then I should see the text "Test media image"
    And I should see the text "Test media document"
