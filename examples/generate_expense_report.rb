require '../lib/xpenser'

MongoMapper.database = 'expense'
Expense.collection.remove

xpenser_tag_hash        = Xpenser.get_all_tags
default_report_expenses = Xpenser.get_default_report_expenses 

default_report_expenses.each do |row|
  row.delete("model")
  row.delete("pk")
  ['report', 'rawamount', 'status', 'created', 'modified', 'user', 'sourceid'].each do |field|
     row['fields'].delete("#{field}")
  end

  # clean this up
  amount = BigDecimal.new(row['fields']['amount'], 2).to_s
  amount = sprintf("%.2f", amount)
     
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


spend_per_company_total = []

['CPAP.com', 'CPAPDropShip.com', 'HMS', 'HMSD'].each do |company|
  amount = Expense.where(:tags => company)
  total = 0
  amount.each do |item|
    total += item['amount']
  end
  spend_per_company_total << ["#{company}", "\$#{sprintf('%.2f',total)}"]
end

amount_total = 0
all_expenses.each do |row| 
  amount_total += row['amount']
end

spend_per_company_total << ["Total", "\$#{sprintf('%.2f', amount_total)}"]

oldest_date = "#{oldest_expense_date.date.month}/#{oldest_expense_date.date.day}/#{oldest_expense_date.date.year}"
newest_date = "#{newest_expense_date.date.month}/#{newest_expense_date.date.day}/#{newest_expense_date.date.year}"

wrapper_array = Array.new

tag_sorted_expenses.each do |row|
  wrapper_array << [Date.parse(row['date'].to_s).strftime('%m/%d/%Y'),  
                    "\$#{sprintf('%.2f', row['amount'])}",
                    row['type'], 
                    row['notes'].gsub(/\t/, ''),
                    row['tags'][0]]
end


Prawn::Document.generate("johnny-expenses.pdf") do

  text "Johnny Goodman's Expenses #{oldest_date} - #{newest_date} (Total: $#{amount_total})"

  table wrapper_array, 
  :headers => ['Date', 'Amount', 'Type', 'Notes', 'Company'], 
  :border_style => :grid, 
  :font_size => 8, 
  :column_widths => { 0 => 75, 1 => 60, 3 => 200 }
  
  start_new_page
  
  text "Totals: "
  
  table spend_per_company_total, 
  :headers => ['Company', 'Total'], 
  :border_style => :grid, 
  :font_size => 8
  #:column_widths => { 0 => 75, 1 => 60, 3 => 200 }

  text "\n\nEmployee:\n\nDate: #{Date.today.strftime('%m/%d/%Y')}\n\nApproved By:\n\nDate:\n\n"
end
