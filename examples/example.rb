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


all_expenses             = Expense.all
date_sorted_expenses     = Expense.sort(:date).all
tag_sorted_expenses      = Expense.sort(:tags).all
amount_sorted_expenses   = Expense.sort(:amount).all
type_sorted_expensese    = Expense.sort(:type).all
oldest_expense_date      = Expense.sort(:date).first
newest_expense_date      = Expense.sort(:date).last

#Surely there is a better way to do this

cpapdotcom_amount = Expense.where(:tags => 'CPAP.com')   
cpapdotcom_total = 0
cpapdotcom_amount.each { |row| cpapdotcom_total += row['amount'] }

cpapdropshipdotcom_amount = Expense.where(:tags => 'CPAPDropShip.com')   
cpapdropshipdotcom_total = 0
cpapdropshipdotcom_amount.each { |row|  cpapdropshipdotcom_total += row['amount'] }

hms_amount = Expense.where(:tags => 'HMS')   
hms_total = 0
hms_amount.each { |row| hms_total += row['amount'] }

hmsd_amount = Expense.where(:tags => 'HMSD')   
hmsd_total = 0
hmsd_amount.each { |row|  hmsd_total += row['amount'] }

amount_total = 0
all_expenses.each { |row| amount_total += row['amount'] }

oldest_date = "#{oldest_expense_date.date.month}/#{oldest_expense_date.date.day}/#{oldest_expense_date.date.year}"
newest_date = "#{newest_expense_date.date.month}/#{newest_expense_date.date.day}/#{newest_expense_date.date.year}"

wrapper_array = Array.new

total_array = [["CPAP.com", cpapdotcom_total], 
               ["CPAPDropShip.com", cpapdropshipdotcom_total], 
               ["HMS", hms_total], 
               ["HMSD", hmsd_total], 
               ["Grand Total", amount_total]]

tag_sorted_expenses.each_with_index do |row, index|
  inside_array = Array.new
  inside_array << Date.parse(row['date'].to_s).strftime('%m/%d/%Y') 
  inside_array << row['amount']
  inside_array << row['type']
  inside_array << row['notes'].gsub(/\t/, '')
  inside_array << row['tags']  #=> To support array row['tags'][0]
  wrapper_array << inside_array
end

#query_results = ExpenseCubicle.query { select :tags, :date }

#pp query_results


Prawn::Document.generate("johnny-expenses.pdf") do

  text "Johnny Goodman's Expenses #{oldest_date} - #{newest_date} (Total: $#{amount_total})"

  table wrapper_array, 
  :headers => ['Date', 'Amount', 'Type', 'Notes', 'Company'], 
  :border_style => :grid, 
  :font_size => 8, 
  :column_widths => { 0 => 75, 1 => 60, 3 => 200 }
  
  # text "CPAP.com Total: #{cpapdotcom_total} \n\n
  #       CPAPDropShip.com Total: #{cpapdropshipdotcom_total} \n\n
  #       Grand Total: #{amount_total}"

  start_new_page
  
  text "Totals: "
  
  table total_array, 
  :headers => ['Company', 'Total'], 
  :border_style => :grid, 
  :font_size => 8
  #:column_widths => { 0 => 75, 1 => 60, 3 => 200 }

  text "\n\nEmployee:\n\nDate: #{Date.today.strftime('%m/%d/%Y')}\n\nApproved By:\n\nDate:\n\n"
end
