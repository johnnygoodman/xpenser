require '../lib/xpenser'

#todo

#1. Clean up examples

#2. Array Support For Tags and Categories

#3. MongoDB For Sorting To Better Feed The PDF 
 
array = Xpenser.get_default_report.to_a

row_array = Array.new
expense_array = Array.new

xpenser_tag_array = Xpenser.get_all_tags

array.each_with_index do |row, index|
  row.delete("model")
  row.delete("pk")
  row['fields'].delete("category") #resolve category id to name and undelete
  
  row['fields']['date'] = Date.parse(row['fields']['date']).strftime('%m/%d/%Y') 
  
  ['report', 'rawamount', 'status', 'created', 'modified', 'user', 'sourceid'].each do |field|
    row['fields'].delete("#{field}")
  end
  
  row['fields']['notes'].gsub!(/\t/, '')
  
  row['fields']['tags'].each do |tag_id|
     name = Xpenser.tag_to_name(tag_id, xpenser_tag_array)
     row['fields']['tags'] = name
  end
  
  row['fields'].each_pair do |k,v|
    row_array << [v]
  end 
  
  row_array.flatten!
  
  expense_array << row_array
  
  row_array = []
  
  break if index > 10
end



pp expense_array

Prawn::Document.generate("multi_page_table.pdf") do

  table expense_array, :headers => ['Notes', 'Amount', 'Company', 'Date', 'Freight'], 
  :border_style => :grid, 
  :font_size => 8, 
  :column_widths => { 1 => 60, 3 => 60 }

end