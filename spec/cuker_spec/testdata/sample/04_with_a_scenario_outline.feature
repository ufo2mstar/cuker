Feature: with a scen outline

  Scenario Outline: scen outline desc <title>
    When this <thing>
    Then that <thang>
    Examples:
      | title  | thing | thang |
      | case 1 | 1     | one   |
      | case 2 | 2     | two   |