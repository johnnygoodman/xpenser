Xpenser Wrapper

== Overview

Ruby Wrapper for Xpenser.com's RESTful API. 

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
 


== TO DO

1. Support tags and category arrays in json feeds
 