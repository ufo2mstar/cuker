#rand comment
@feat_tag1 @feat_tag2
Feature: feat name 123456 12345 12 123 1234 1 1234 123456 12   1 12345 123
  feat desc 123 1 1234 123456 12345 1234 12345 123 12 123456   12 1

  Background: bg name 123456 12345 12 12 123 1  12345 123456 1234  123 1234 1
  bg desc
  bg desc 12 1234 12345 123456 123 1  1 123456 123 1234  12345 12
    Given bg step 1
    When bg step 2
    Then bg step 3
#    in bg comment
    And bg step 4
    But bg step 5

    #rand BG comment

  @s_tag1 @s_tag2
  @s_tag3
  Scenario: scen name 123  12 12345 12 123456 1234 12345  1 1234 123 123456 1
  scen desc line 0

  scen desc line 1 123456 1234 12345  12 123456 12  123 1234 1 1 12345 123
  scen desc line 2 123 1234  12 12345 1 1234  12 123456 123456 12345 1 123

    Given bg step 1
    When bg step 2
    Then bg step 3
    And bg step 4
    But bg step 5
    When table
      | tab | tab | tab |
      | 1   |     | 1   |
      |||     |
      | two | two |     |
    Then kod 1
    And kod2
#rand inbetween S comment
    But kod3
    * kod4

#rand after S comment

  @s_tag1
  @so_tag1
    #rand after so tag comment
  Scenario Outline: scen outline name <title> 1 12   123 1234 12 12345 123 1 12345 123456 123456 1234
  scen outline desc 12345 1234  1 12 1234 123456 1 123456 123 12345 123 12
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
      |  |
      #rand in SO table comment
      | two |
    Then that <thang>

#rand before SO examples comment|
  @so_ex_tag1
  @s_tag3 @so_ex_tag2
    Examples: example name 1234 123 123456 1 12345 1 12345 123456  12 1234 12  123
    example desc
    123 12 12345  1234 123456 123 123456  12345 1234 12 1 1
      | title        | thing | thang |
      | case 1       | 1     | one   |
      | case 2       | 1     | one   |
      |              |       |       |
      | blank case 3 |       |       |
      |              |       |       |
        #rand before  ex1 SO examples comment|

  @so_ex2_tag1
  @s_tag3 @so_ex_tag2
    Examples: example name  123 123456 12 1 1234 1 12345 123 12 1234 123456  12345
    example desc 123 1234  12 12345 1 1234  12 123456 123456 12345 1 123
      | title        | thing |  | thang |  |
      | case 1       | 1     |  | one   |  |
      | case 2       | 1     |  | one   |  |
      |              |       |  |       |  |
      | blank case 3 |       |  |       |  |
      |              |       |  |       |  |
#rand after ex2 SO examples comment|