
require 'rubyXL'

# ============================================
# ===========   Read Example   ===============
# ============================================

workbook = RubyXL::Parser.parse './xlsx_500_rows.xlsx'

worksheets = workbook.worksheets
puts "Found #{worksheets.count} worksheets"

worksheets.each do |worksheet|
  puts "Reading: #{worksheet.sheet_name}"
  num_rows = 0

  worksheet.each { |row|
    cell = row[0]
    next if cell.value.to_i == 0
    # cell.change_contents(cell.value.to_i+100, cell.formula) # Sets value of cell A1 to empty string, preserves formula
    cell.change_contents(cell.value.to_i+100) # Sets value of cell A1 to empty string, preserves formula


    # row && row.cells.each { |cell|
    #   val = cell && cell.value
    # }

    row && row.cells.each { |cell|
      val = cell && cell.value
      cell.change_contents(cell.value.to_i+100) # Sets value of cell A1 to empty string, preserves formula
      # if val
      # cell.change_contents(val.to_i+100, cell.formula) # Sets value of cell A1 to empty string, preserves formula
      # end
      # print(val)
    }
  }

  worksheet.each do |row|
    row_cells = row.cells.map{ |cell| cell.value }
    num_rows += 1

    # uncomment to print out row values
    puts row_cells.join " "
  end
  puts "Read #{num_rows} rows"
end

puts 'Done'
