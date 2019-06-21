# require 'rubyXL'
# require 'rubyXL/convenience_methods/cell'
#
# workbook = RubyXL::Parser.parse './Book1.xlsx'
#
#
# worksheets = workbook.worksheets
#
# worksheets.each do |worksheet|
#   puts "Reading: #{worksheet.sheet_name}"
#   num_rows = 0
#
#   worksheet.each do |row|
#     row_cells = row.cells.map(&:value)
#     num_rows += 1
#
#     # uncomment to print out row values
#     puts row_cells.join ' '
#   end
#   puts "Read #{num_rows} rows"
# end
#
# workbook.write("res.xlsx")
#
# puts 'Done'
