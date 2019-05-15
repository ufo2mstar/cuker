#rand comment
@feat_tag1 @feat_tag2
Feature: feat name
  feat desc

  Background: bg name
  bg desc
    Given bg step 1
    When bg step 2
    Then bg step 3
#    in bg comment
    And bg step 4
    But bg step 5

    #rand BG comment

  @s_tag1 @s_tag2
  @s_tag3
  Scenario: scen name
  scen desc line 1
  scen desc line 2

    Given bg step 1
    When bg step 2
    Then bg step 3
    And bg step 4
    But bg step 5
    When table
      | tab |
      | 1   |
      | two |
    Then kod 1
    And kod2
#rand inbetween S comment
    But kod3
    * kod4

#rand after S comment

  @s_tag1
  @so_tag1
    #rand after so tag comment
  Scenario Outline: scen outline name <title>
  scen outline desc
    Given bg step 1
    When bg step 2
    Then bg step 3
    And bg step 4
    But bg step 5
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
      | title        | thing | thang |
      | case 1       | 1     | one   |
      | case 2       | 1     | one   |
      |              |       |       |
      | blank case 3 |       |       |
      |              |       |       |
#rand after SO examples comment|