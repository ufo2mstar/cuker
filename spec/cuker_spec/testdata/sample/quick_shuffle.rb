ary = [[nil], [nil]]
inp = ''
(1..6).each do |i|
  ary << [('a'..('a'.ord+i).chr).to_a.join]
  ary << [('a'..('a'.ord+i).chr).to_a.join]
  # ary << [(1..i).to_a.join]
  # ary += [',','.','-','"','+','_','=','?','|']
end

20.times do |x|
puts ary.shuffle.join ' '
end
