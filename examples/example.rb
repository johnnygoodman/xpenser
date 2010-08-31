require '../lib/xpenser'

MongoMapper.database = 'expense'
Expense.collection.remove

xpenser_tag_hash        = Xpenser.get_all_tags
default_report_expenses = Xpenser.get_default_report_expenses.to_a

default_report_expenses.each do |row|
  row.delete("model")
  row.delete("pk")
  ['report', 'rawamount', 'status', 'created', 'modified', 'user', 'sourceid'].each do |field|
     row['fields'].delete("#{field}")
   end
  
  # Deleted Fields 
  # :report => row['fields']['report'],  
  #  :modified => row['fields']['modified'],
  #  :rawamount => row['fields']['rawamount'],
  #  :status => row['fields']['status'],
  #  :created => row['fields']['created'],
  #  :user => row['fields']['user'], 
  #  :sourceid => row['fields']['sourceid'],
     
  # Waiting on answer in google groups: 
  amount = BigDecimal.new(row['fields']['amount'], 2).to_s
  #puts "amount pre sprintf #{amount}"
  amount = sprintf("%.2f", amount)
  #puts "amount post sprintf #{amount}"
     
  Expense.create(:notes => row['fields']['notes'],
                 :amount => "#{amount}",
                 :tags => Xpenser.tag_id_to_name(row['fields']['tags'], xpenser_tag_hash),
                 :date => row['fields']['date'],
                 :type => row['fields']['type'])              
end


date_sorted_expenses     = Expense.sort(:date).all
tag_sorted_expenses      = Expense.sort(:tags).all
amount_sorted_expenses   = Expense.sort(:amount).all
type_sorted_expensese    = Expense.sort(:type).all
oldest_expense_date      = Expense.sort(:date).first
newest_expense_date      = Expense.sort(:date).last
group_by_date            = Expense.group(:date)

oldest_date = "#{oldest_expense_date.date.month}/#{oldest_expense_date.date.day}/#{oldest_expense_date.date.year}"
newest_date = "#{newest_expense_date.date.month}/#{newest_expense_date.date.day}/#{newest_expense_date.date.year}"

wrapper_array = Array.new

tag_sorted_expenses.each_with_index do |row, index|
  inside_array = Array.new
  inside_array << Date.parse(row['date'].to_s).strftime('%m/%d/%Y') 
  inside_array << row['amount']
  inside_array << row['type']
  inside_array << row['notes'].gsub(/\t/, '')
  inside_array << row['tags']  #=> To support array row['tags'][0]
  wrapper_array << inside_array
end

query_results = ExpenseCubicle.query { select :tags, :date }

pp query_results


Prawn::Document.generate("multi_page_table.pdf") do

  text "Johnny Goodman's Expenses #{oldest_date} - #{newest_date}"

  table wrapper_array, 
  :headers => ['Date', 'Amount', 'Type', 'Notes', 'Company'], 
  :border_style => :grid, 
  :font_size => 8, 
  :column_widths => { 0 => 75, 1 => 60, 3 => 200 }

end
