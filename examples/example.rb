require '../lib/xpenser'

default_expenses = Xpenser.get_default_report_expenses

default_expenses.each do |row|
  pp row
end


# => 
# 
# {"model"=>"xpense.expense",
#  "fields"=>
#   {"report"=>89791,
#    "modified"=>"2010-08-31 08:30:26",
#    "rawamount"=>"500.00",
#    "category"=>36675,
#    "sourceid"=>"0MLdYB-1Oqk2D0RRD-000sdB",
#    "notes"=>"Endicia.com - US Mail Shipments Conf 188055",
#    "amount"=>"500.00",
#    "tags"=>[4107],
#    "date"=>"2010-08-31 10:30:26",
#    "type"=>"Freight",
#    "user"=>17243,
#    "status"=>1,
#    "created"=>"2010-08-31 08:30:26"},
#  "pk"=>1576856}
# {"model"=>"xpense.expense",
#  "fields"=>
#   {"report"=>89791,
#    "modified"=>"2010-08-31 08:28:16",
#    "rawamount"=>"400.00",
#    "category"=>36675,
#    "sourceid"=>"0MZT8f-1OVLOv1KOr-00LyNB",
#    "notes"=>"Endicia.com - US Mail Shipments Conf 132513",
#    "amount"=>"400.00",
#    "tags"=>[4107],
#    "date"=>"2010-08-31 10:28:16",
#    "type"=>"Freight",
#    "user"=>17243,
#    "status"=>1,
#    "created"=>"2010-08-31 08:28:16"},
#  "pk"=>1576853}