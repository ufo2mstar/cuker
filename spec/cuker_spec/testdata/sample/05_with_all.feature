#rand comment
@feat_tag1 @feat_tag2
Feature: with a scen outline

  Background: bg desc
    Given some setup

  @s_tag1 @s_tag2
  Scenario: scen desc
    Given this
    When that:
    |tab|
    |1  |
    |two|
    Then kod

  @s_tag1 @so_tag1
  Scenario Outline: scen outline desc <title>
    When this <thing>
    Then that <thang>
    Examples:
      | title  | thing | thang |
      | case 1 | 1     | one   |
      | case 2 | 2     | two   |
