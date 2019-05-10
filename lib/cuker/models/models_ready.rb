class Item
  attr_accessor :content

  def initialize content_str
    @content = content_str
  end

  def to_s
    @content
  end
end

class Step < Item
  attr_accessor :keyword, :line
  attr_accessor :table # optional
end

class Comment < Item

end

class InlineComment < Comment

end

class Tag < Item

end

class TableRow < Item

end

class Collection < Item
  attr_accessor :items
  attr_reader :keyword

  def initialize content_str
    super content_str
    @items = []
  end

  def to_s
    ([super] + items.map(&:to_s)).join "\n"
  end
end

class Tags < Collection

end

class Table < Collection
  attr_accessor :title_row, :table_rows
  def initialize content_str
    super content_str
    @table_rows = []
    @title_row = @items[0]
    @table_rows = @items[1..-1]
  end

end

class Examples < Table

end

class SimpleGherkinCollection < Collection
  attr_accessor :title, :comments

  def initialize content_str, keyword
    super content_str
    @title = parse_title content_str, keyword
  end

  def parse_title content, keyword
    match = content[/^\s*#{keyword}(.*)$/, 1]
    warn "no matches for '#{keyword}' in '#{content}'" unless match
    match
  end
end

class Background < SimpleGherkinCollection
  def initialize content_str
    @keyword = "Background:"
    super content_str, keyword
  end
end

class TaggedGherkinCollection < SimpleGherkinCollection
  attr_accessor :tags

end

class Feature < TaggedGherkinCollection
  attr_accessor :background

  def initialize content_str
    @keyword = "Feature:"
    super content_str, keyword
    #todo: think about item ordering
  end

  def comments= content
    @items << content
    @comments = content
  end

  def tags= content
    @items << content
    @tags = content
  end

end

class Scenario < TaggedGherkinCollection
  attr_accessor :steps

  def initialize content_str, keyword = "Scenario:"
    @steps = []
    @keyword = keyword
    super content_str, @keyword
  end
end

class ScenarioOutline < Scenario
  attr_accessor :examples

  def initialize content_str, keyword = "Scenario Outline:"
    @keyword = keyword
    super content_str, @keyword
  end
end
