#rand comment
@feat_tag1 @feat_tag2
Feature: feat name ab abcde abcdefg abcdefg abc   abcde abcdef abcd ab abc abcd abcdef
  ab abcde abcde abcdef abcdefg abc abcd abcdefg abc ab  abcd abcdef

  Background: bg name abcdef abcdefg abcdef  abcde abcde abcd ab abc abcd ab abcdefg  abc
  bg desc
  bg desc ab abcdef  abc ab abc abcdefg  abcd abcdef abcdefg abcd abcde abcde
  abcd abcdef abcdefg  abcde abc  abcdef abcdefg ab abcde abcd ab abc
    Given bg step 1
    When bg step 2
    Then bg step 3
#    in bg comment
    And bg step 4
    But bg step 5

    #rand BG comment

  @s_tag1 @s_tag2
  @s_tag3
  Scenario: scen name abcde ab ab abcdef abc abcdef abcdefg abcde abcdefg abcd abcd abc
  scen desc line 0

  scen desc line 2 abcd abc ab abcdefg abc abcdef ab abcdef  abcd abcde abcdefg  abcde
  scen desc line 3 abcd abcdefg ab abcdef abc abcdef abcdefg abcd  ab abcde  abc abcde

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
  Scenario Outline: scen outline name <title>   abcde abcdefg abc ab   abcd abcdefg abcdef abcd ab abcde abcdef abc
  scen outline desc abcde abcdef abcdefg abcdef ab abc abcde abcd  abcd ab abc abcdefg
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
    Examples: example name 1234 123 - 123456 1 12345 --- 1 12345 123456  '12' 1234 12  123
    example desc
      | title        | thing | thang |
      | case 1       | 1     | one   |
      | case 2       | 1     | one   |
      |              |       |       |
      | blank case 3 |       |       |
      |              |       |       |
        #rand before  ex1 SO examples comment|

  @so_ex2_tag1
  @s_tag3 @so_ex_tag2
    Examples: example name  123 123456 12 1 1234 1 12345 123.. 12 ,1234 123456  12345
    example desc abcd abcdefg ab abcdef abc abcdef abcdefg abcd  ab abcde  abc abcde
    abcde  abcdef abcdefg abcde abcd  abc abcd ab abcdefg ab abc abcd
      | title        | thing |  | thang |  |
      | case 1       | 1     |  | one   |  |
      | case 2       | 1     |  | one   |  |
      |              |       |  |       |  |
      | blank case 3 |       |  |       |  |
      |              |       |  |       |  |
#rand after ex2 SO examples comment|