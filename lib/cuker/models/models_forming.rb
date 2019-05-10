# class Item
#   attr_accessor :content
# end
#
# class Step < Item
#   attr_accessor :keyword, :line
#   attr_accessor :table # optional
# end
#
# class Comment < Item
#
# end
#
# class InlineComment < Comment
#
# end
#
# class Tag < Item
#
# end
#
# class Row < Item
#
# end
#
# class Collection < Item
#   attr_accessor :items
# end
#
# class Tags < Collection
#
# end
#
# class Table < Collection
#
# end
#
# class Example < Table
#
# end
#
# class SimpleGherkinCollection < Collection
#   attr_accessor :title, :comments
# end
#
# class Background < SimpleGherkinCollection
#
# end
#
# class TaggedGherkinCollection < SimpleGherkinCollection
#   attr_accessor :tags
# end
#
# class Feature < TaggedGherkinCollection
#   attr_accessor :background
#   # attr_accessor :collections
# end
#
# class Scenario < TaggedGherkinCollection
#
# end
#
# class ScenarioOutline < Scenario
#   attr_accessor :examples
# end
