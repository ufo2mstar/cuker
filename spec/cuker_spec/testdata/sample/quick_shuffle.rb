ary = [[nil], [nil]]
inp = ''
(1..6).each do |i|
  ary << [(1..i).to_a.join]
  ary << [(1..i).to_a.join]
end

20.times do |x|
puts ary.shuffle.join ' '
end
