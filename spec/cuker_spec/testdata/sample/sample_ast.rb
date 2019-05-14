module Cuker
  OLD_AST =
      {
          feature: {type: :Feature,
                    tags: [{type: :Tag,
                            location: {line: 1, column: 1},
                            name: "@feature_tag1"},
                           {type: :Tag,
                            location: {line: 1, column: 15},
                            name: "@feature_tag2"},
                           {type: :Tag,
                            location: {line: 1, column: 29},
                            name: "@feat_tag3"}],
                    location: {line: 2, column: 1},
                    language: "en",
                    keyword: "Feature",
                    name: "feature name",
                    description: "  feature description",
                    children: [{type: :Background,
                                location: {line: 5, column: 4},
                                keyword: "Background",
                                name: "background name",
                                description: "    background description",
                                steps: [{type: :Step,
                                         location: {line: 7, column: 5},
                                         keyword: "* ",
                                         text: "a step"}]},
                               {type: :Scenario,
                                tags: [{type: :Tag,
                                        location: {line: 9, column: 3},
                                        name: "@scenario_tag"}],
                                location: {line: 10, column: 3},
                                keyword: "Scenario",
                                name: "scenario name",
                                description: "    scenario description",
                                steps: [{type: :Step,
                                         location: {line: 12, column: 5},
                                         keyword: "* ",
                                         text: "a step with a table",
                                         argument: {type: :DataTable,
                                                    location: {line: 13, column: 7},
                                                    rows: [{type: :TableRow,
                                                            location: {line: 13, column: 7},
                                                            cells: [{type: :TableCell,
                                                                     location: {line: 13, column: 9},
                                                                     value: "a table"}]}]}}]},
                               {type: :ScenarioOutline,
                                tags: [{type: :Tag,
                                        location: {line: 15, column: 3},
                                        name: "@outline_tag"}],
                                location: {line: 16, column: 3},
                                keyword: "Scenario Outline",
                                name: "outline name",
                                description: "    outline description",
                                steps: [{type: :Step,
                                         location: {line: 18, column: 5},
                                         keyword: "* ",
                                         text: "a step with a doc string",
                                         argument: {type: :DocString,
                                                    location: {line: 19, column: 7},
                                                    contentType: "content_type",
                                                    content: "  lots of text"}}],
                                examples: [{type: :Examples,
                                            tags: [{type: :Tag,
                                                    location: {line: 23, column: 3},
                                                    name: "@example_tag"}],
                                            location: {line: 24, column: 3},
                                            keyword: "Examples",
                                            name: "examples name",
                                            description: "    examples description",
                                            tableHeader: {type: :TableRow,
                                                          location: {line: 26, column: 5},
                                                          cells: [{type: :TableCell,
                                                                   location: {line: 26, column: 7},
                                                                   value: "param"}]},
                                            tableBody: [{type: :TableRow,
                                                         location: {line: 27, column: 5},
                                                         cells: [{type: :TableCell,
                                                                  location: {line: 27, column: 7},
                                                                  value: "value"}]}]}]}],
          },
          comments: [{type: :Comment,
                      location: {line: 22, column: 1},
                      text: "                # Random file comment"}],
          type: :GherkinDocument
      }

  FULL_AST = {
      :type => :GherkinDocument,
      :feature => {
          :type => :Feature,
          :tags => [
              {
                  :type => :Tag,
                  :location => {
                      :line => 2,
                      :column => 1
                  },
                  :name => "@feat_tag1"
              },
              {
                  :type => :Tag,
                  :location => {
                      :line => 2,
                      :column => 12
                  },
                  :name => "@feat_tag2"
              }
          ],
          :location => {
              :line => 3,
              :column => 1
          },
          :language => "en",
          :keyword => "Feature",
          :name => "feat name",
          :description => "  feat desc",
          :children => [
              {
                  :type => :Background,
                  :location => {
                      :line => 6,
                      :column => 3
                  },
                  :keyword => "Background",
                  :name => "bg name",
                  :description => "  bg desc",
                  :steps => [
                      {
                          :type => :Step,
                          :location => {
                              :line => 8,
                              :column => 5
                          },
                          :keyword => "Given ",
                          :text => "some setup"
                      }
                  ]
              },
              {
                  :type => :Scenario,
                  :tags => [
                      {
                          :type => :Tag,
                          :location => {
                              :line => 12,
                              :column => 3
                          },
                          :name => "@s_tag1"
                      },
                      {
                          :type => :Tag,
                          :location => {
                              :line => 12,
                              :column => 11
                          },
                          :name => "@s_tag2"
                      },
                      {
                          :type => :Tag,
                          :location => {
                              :line => 13,
                              :column => 3
                          },
                          :name => "@s_tag3"
                      }
                  ],
                  :location => {
                      :line => 14,
                      :column => 3
                  },
                  :keyword => "Scenario",
                  :name => "scen name",
                  :description => "  scen desc line 1\n  scen desc line 2",
                  :steps => [
                      {
                          :type => :Step,
                          :location => {
                              :line => 18,
                              :column => 5
                          },
                          :keyword => "Given ",
                          :text => "this"
                      },
                      {
                          :type => :Step,
                          :location => {
                              :line => 19,
                              :column => 5
                          },
                          :keyword => "When ",
                          :text => "that:",
                          :argument => {
                              :type => :DataTable,
                              :location => {
                                  :line => 20,
                                  :column => 7
                              },
                              :rows => [
                                  {
                                      :type => :TableRow,
                                      :location => {
                                          :line => 20,
                                          :column => 7
                                      },
                                      :cells => [
                                          {
                                              :type => :TableCell,
                                              :location => {
                                                  :line => 20,
                                                  :column => 9
                                              },
                                              :value => "tab"
                                          }
                                      ]
                                  },
                                  {
                                      :type => :TableRow,
                                      :location => {
                                          :line => 21,
                                          :column => 7
                                      },
                                      :cells => [
                                          {
                                              :type => :TableCell,
                                              :location => {
                                                  :line => 21,
                                                  :column => 9
                                              },
                                              :value => "1"
                                          }
                                      ]
                                  },
                                  {
                                      :type => :TableRow,
                                      :location => {
                                          :line => 22,
                                          :column => 7
                                      },
                                      :cells => [
                                          {
                                              :type => :TableCell,
                                              :location => {
                                                  :line => 22,
                                                  :column => 9
                                              },
                                              :value => "two"
                                          }
                                      ]
                                  }
                              ]
                          }
                      },
                      {
                          :type => :Step,
                          :location => {
                              :line => 23,
                              :column => 5
                          },
                          :keyword => "Then ",
                          :text => "kod"
                      },
                      {
                          :type => :Step,
                          :location => {
                              :line => 24,
                              :column => 5
                          },
                          :keyword => "And ",
                          :text => "kod"
                      },
                      {
                          :type => :Step,
                          :location => {
                              :line => 26,
                              :column => 5
                          },
                          :keyword => "But ",
                          :text => "kod"
                      },
                      {
                          :type => :Step,
                          :location => {
                              :line => 27,
                              :column => 5
                          },
                          :keyword => "* ",
                          :text => "kod"
                      }
                  ]
              },
              {
                  :type => :ScenarioOutline,
                  :tags => [
                      {
                          :type => :Tag,
                          :location => {
                              :line => 30,
                              :column => 3
                          },
                          :name => "@s_tag1"
                      },
                      {
                          :type => :Tag,
                          :location => {
                              :line => 31,
                              :column => 3
                          },
                          :name => "@so_tag1"
                      }
                  ],
                  :location => {
                      :line => 33,
                      :column => 3
                  },
                  :keyword => "Scenario Outline",
                  :name => "scen outline name <title>",
                  :description => "  scen outline desc",
                  :steps => [
                      {
                          :type => :Step,
                          :location => {
                              :line => 35,
                              :column => 5
                          },
                          :keyword => "When ",
                          :text => "this <thing>"
                      },
                      {
                          :type => :Step,
                          :location => {
                              :line => 37,
                              :column => 5
                          },
                          :keyword => "And ",
                          :text => "this <thing>",
                          :argument => {
                              :type => :DataTable,
                              :location => {
                                  :line => 38,
                                  :column => 7
                              },
                              :rows => [
                                  {
                                      :type => :TableRow,
                                      :location => {
                                          :line => 38,
                                          :column => 7
                                      },
                                      :cells => [
                                          {
                                              :type => :TableCell,
                                              :location => {
                                                  :line => 38,
                                                  :column => 9
                                              },
                                              :value => "tab"
                                          }
                                      ]
                                  },
                                  {
                                      :type => :TableRow,
                                      :location => {
                                          :line => 39,
                                          :column => 7
                                      },
                                      :cells => [
                                          {
                                              :type => :TableCell,
                                              :location => {
                                                  :line => 39,
                                                  :column => 9
                                              },
                                              :value => "1"
                                          }
                                      ]
                                  },
                                  {
                                      :type => :TableRow,
                                      :location => {
                                          :line => 41,
                                          :column => 7
                                      },
                                      :cells => [
                                          {
                                              :type => :TableCell,
                                              :location => {
                                                  :line => 41,
                                                  :column => 9
                                              },
                                              :value => "two"
                                          }
                                      ]
                                  }
                              ]
                          }
                      },
                      {
                          :type => :Step,
                          :location => {
                              :line => 42,
                              :column => 5
                          },
                          :keyword => "Then ",
                          :text => "that <thang>"
                      }
                  ],
                  :examples => [
                      {
                          :type => :Examples,
                          :tags => [
                              {
                                  :type => :Tag,
                                  :location => {
                                      :line => 45,
                                      :column => 3
                                  },
                                  :name => "@so_ex_tag1"
                              },
                              {
                                  :type => :Tag,
                                  :location => {
                                      :line => 46,
                                      :column => 3
                                  },
                                  :name => "@s_tag3"
                              },
                              {
                                  :type => :Tag,
                                  :location => {
                                      :line => 46,
                                      :column => 11
                                  },
                                  :name => "@so_ex_tag2"
                              }
                          ],
                          :location => {
                              :line => 47,
                              :column => 5
                          },
                          :keyword => "Examples",
                          :name => "example name",
                          :description => "    example desc",
                          :tableHeader => {
                              :type => :TableRow,
                              :location => {
                                  :line => 49,
                                  :column => 7
                              },
                              :cells => [
                                  {
                                      :type => :TableCell,
                                      :location => {
                                          :line => 49,
                                          :column => 9
                                      },
                                      :value => "title"
                                  },
                                  {
                                      :type => :TableCell,
                                      :location => {
                                          :line => 49,
                                          :column => 18
                                      },
                                      :value => "thing"
                                  },
                                  {
                                      :type => :TableCell,
                                      :location => {
                                          :line => 49,
                                          :column => 26
                                      },
                                      :value => "thang"
                                  }
                              ]
                          },
                          :tableBody => [
                              {
                                  :type => :TableRow,
                                  :location => {
                                      :line => 50,
                                      :column => 7
                                  },
                                  :cells => [
                                      {
                                          :type => :TableCell,
                                          :location => {
                                              :line => 50,
                                              :column => 9
                                          },
                                          :value => "case 1"
                                      },
                                      {
                                          :type => :TableCell,
                                          :location => {
                                              :line => 50,
                                              :column => 18
                                          },
                                          :value => "1"
                                      },
                                      {
                                          :type => :TableCell,
                                          :location => {
                                              :line => 50,
                                              :column => 26
                                          },
                                          :value => "one"
                                      }
                                  ]
                              },
                              {
                                  :type => :TableRow,
                                  :location => {
                                      :line => 51,
                                      :column => 7
                                  },
                                  :cells => [
                                      {
                                          :type => :TableCell,
                                          :location => {
                                              :line => 51,
                                              :column => 9
                                          },
                                          :value => "case 2"
                                      },
                                      {
                                          :type => :TableCell,
                                          :location => {
                                              :line => 51,
                                              :column => 18
                                          },
                                          :value => "2"
                                      },
                                      {
                                          :type => :TableCell,
                                          :location => {
                                              :line => 51,
                                              :column => 26
                                          },
                                          :value => "two"
                                      }
                                  ]
                              }
                          ]
                      }
                  ]
              }
          ]
      },
      :comments => [
          {
              :type => :Comment,
              :location => {
                  :line => 1,
                  :column => 1
              },
              :text => "#rand comment"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 10,
                  :column => 1
              },
              :text => "    #rand BG comment"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 25,
                  :column => 1
              },
              :text => "#rand inbetween S comment"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 28,
                  :column => 1
              },
              :text => "#rand after S comment"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 32,
                  :column => 1
              },
              :text => "    #rand after so tag comment"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 36,
                  :column => 1
              },
              :text => "    #rand in SO comment"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 40,
                  :column => 1
              },
              :text => "      #rand in SO table comment"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 44,
                  :column => 1
              },
              :text => "#rand before SO examples comment|"
          },
          {
              :type => :Comment,
              :location => {
                  :line => 52,
                  :column => 1
              },
              :text => "#rand after SO examples comment|"
          }
      ]
  }


  BLANK_AST = {
      feature: {
          type: :Feature,
          tags: [],
          location: {line: 1, column: 1},
          language: "en",
          keyword: "Feature",
          name: "test",
          children: []
      },
      comments: [],
      type: :GherkinDocument
  }
end