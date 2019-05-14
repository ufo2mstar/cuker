#rand comment
@feat_tag1 @feat_tag2
Feature: feat name
  feat desc

  Background: bg name
  bg desc
    Given some setup

    #rand BG comment

  @s_tag1 @s_tag2
  @s_tag3
  Scenario: scen name
  scen desc line 1
  scen desc line 2

    Given this
    When that:
      | tab |
      | 1   |
      | two |
    Then kod
    And kod
#rand inbetween S comment
    But kod
    * kod
#rand after S comment

  @s_tag1
  @so_tag1
    #rand after so tag comment
  Scenario Outline: scen outline name <title>
  scen outline desc
    When this <thing>
    #rand in SO comment
    And this <thing>
      | tab |
      | 1   |
      #rand in SO table comment
      | two |
    Then that <thang>

#rand before SO examples comment|
  @so_ex_tag1
  @s_tag3 @so_ex_tag2
    Examples: example name
    example desc
      | title  | thing | thang |
      | case 1 | 1     | one   |
      | case 2 | 2     | two   |
#rand after SO examples comment|