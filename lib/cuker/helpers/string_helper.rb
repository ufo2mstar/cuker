module StringHelper

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

  def add_newlines_regex(str, max_len)
    str.scan(/.{1,#{max_len}}.*?(?:\b|$)/).join "\n"
  end

  def add_newlines(str, max_len)
    words = str.split(' ')
    lines = []
    current_line = ''
    until words.empty?
      current_line += " #{words.shift}"
      if current_line.length >= max_len
        lines << current_line
        current_line = ''
      end
    end
    lines.push(current_line).join("\n")
  end
end