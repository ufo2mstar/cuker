# # frozen_string_literal: true
#
# require 'rubyXL'
# require 'rubyXL/convenience_methods/cell'
#
# # ============================================
# # ===========   Read Example   ===============
# # ============================================
#
# workbook = RubyXL::Parser.parse './xlsx_500_rows.xlsx'
#
# worksheets = workbook.worksheets
# puts "Found #{worksheets.count} worksheets"
#
# worksheets.each do |worksheet|
#   puts "Reading: #{worksheet.sheet_name}"
#   num_rows = 0
#
#   # worksheet[0][0].change_contents("kod", worksheet[0][0].formula)
#   # worksheet.add_cell(0, 0, 'A1')
#
#   worksheet.each do |row|
#     next if row.r == 1
#     cell = row[0]
#     next if cell.value.to_i == 0
#
#     # cell.change_contents(cell.value.to_i+100, cell.formula) # Sets value of cell A1 to empty string, preserves formula
#     cell.change_contents(cell.value.to_i + 100) # Sets value of cell A1 to empty string, preserves formula
#
#     # row && row.cells.each { |cell|
#     #   val = cell && cell.value
#     # }
#
#     # row&.cells&.each do |cell|
#     #   val = cell&.value
#     #   cell.change_contents(cell.value.to_i + 100) # Sets value of cell A1 to empty string, preserves formula
#     #   # if val
#     #   # cell.change_contents(val.to_i+100, cell.formula) # Sets value of cell A1 to empty string, preserves formula
#     #   # end
#     #   # print(val)
#     # end
#   end
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
#
#
