Xpenser Wrapper

== Overview

Ruby Wrapper for Xpenser.com's REST API. 

== Examples

require 'rubygems'
require 'xpenser'

result_array = Xpenser.get_default_report_expenses 

pp result_array 

# => [#<Expense category: [36677], notes: "Microsoft.com - TechNet Data Import Helper  Subscription", amount: 377, expense_id: nil, _id: BSON::ObjectID('4c788cd36cd169218e00005a'), tags: [CPAP.com], date: Wed Aug 04 18:43:00 UTC 2010, type: "Web Software Rental">,
 #<Expense category: [36675], notes: "Endicia.com - US Mail Shipments Conf 161474", amount: 400, expense_id: nil, _id: BSON::ObjectID('4c788cd36cd169218e000001'), tags: [CPAP.com], date: Wed Aug 25 21:43:45 UTC 2010, type: "Freight">,

result_array.each do |row|
	puts row['fields']['amount']  #=> 400.00
end
 


== 0.0.1 Supports 

* Expenses
** Get All From Default Report
** Get All Given Report ID 
** Get One With Given Expense ID
* Reports
** Get Report Data Given Report ID
** Get Current Default Report
** Get All Reports With A Given Status
*** :needs_action
*** :active
*** :submitted
*** :approved
*** :rejected
*** :paid
*** :archived
* Tags
** Get All 
** Get One Tag Given Tag ID

No Support For: 

* Delete/Update/Create
* OAuth
* Users
* Receipts





== TO DO

1. Fill out class methods for all supported xpenser Expenses, Tags, Categories and Reports. 

2. Support tags arrays in json feeds (DONE)

3. Support category arrays in json feeds

4. Clean up Class structure

5. Figure out how to store precision 2 floats in mongodb (DONE)

6. Implement Cubicle for sum, ave, group and count mongo functionality (POSTPONED)

7. Implement Hashie (POSTPONED)

8. Add currency class (POSTPONED)