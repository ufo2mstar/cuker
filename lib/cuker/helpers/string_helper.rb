module StringHelper

  def add_newlines_regex(str, max_len)
    str.scan(/.{1,#{max_len}}.*?(?:\b|$)/).join "\n"
  end

  def add_newlines!(str, max_len)
    index = max_len - 1
    until index >= str.length
      if str[index] == ' '
        str[index] = "\n"
        index += max_len
      else
        index += 1
      end
    end
    str
  end

  def add_newlines(str, max_len)
    words = str.split(' ')
    lines = []
    current_line = []
    current_len = 0
    until words.empty?
      next_word = words.shift
      current_line << next_word
      current_len += next_word.length + 1
      if current_len >= max_len
        lines << current_line.join(' ')
        current_line = []
        current_len = 0
      end
    end
    lines << current_line.join(' ') unless current_line.empty?
    lines.join("\n")
  end

end