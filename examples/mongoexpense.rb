require '../lib/xpenser'

MongoMapper.database = 'expense'
Expense.collection.remove

xpenser_tag_array = Xpenser.get_all_tags
delete_fields = ['report', 'rawamount', 'status', 'created', 'modified', 'user', 'sourceid']
default_report_expenses = Xpenser.get_default_report_expenses

puts default_report_expenses.class

default_report_expenses.each do |row|
  row.delete("model")
  row.delete("pk")
  delete_fields.each do |field|
    row['fields'].delete("#{field}")
  end
    
  Expense.create(:category => row['fields']['category'], 
                 :notes => row['fields']['notes'], 
                 :amount => row['fields']['amount'], 
                 :tags => Xpenser.tag_to_name(row['fields']['tags'], xpenser_tag_array), 
                 :date => row['fields']['date'], 
                 :type => row['fields']['type'])  
end

tag_sorted_expenses = Expense.sort(:tags).all
amount_sorted_expenses  = Expense.sort(:amount).all
category_sorted_expenses  = Expense.sort(:category).all

pp tag_sorted_expenses

#returned_array = Xpenser.tag_to_name(4107, xpenser_tag_array) # returns array

#puts "Returned Array:\n\n"
#pp returned_array




#default_report_expenses.each do |row|
#  puts row.inspect
  #puts row['fields']['amount']
  #puts row['fields']['notes']
#end


#pp default_report_expenses[0]['fields']['amount']

#pp default_report_expenses[1]

#puts default_report['fields'][0]
 


#http://stackoverflow.com/questions/2113886/accesing-data-from-httparty-response
 



#array = Crack::JSON.parse(default_report)

#pp array
#puts default_report['fields']['amount']


=begin
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
  
  something = Expense.save
  
  puts something
  
  row_array.flatten!
  
  expense_array << row_array
  
  row_array = []
  

end



pp expense_array

Prawn::Document.generate("multi_page_table.pdf") do

  table expense_array, :headers => ['Notes', 'Amount', 'Company', 'Date', 'Freight'], 
  :border_style => :grid, 
  :font_size => 8, 
  :column_widths => { 1 => 60, 3 => 60 }

end
=end