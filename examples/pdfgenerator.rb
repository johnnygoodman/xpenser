require 'rubygems'
require 'prawn'
require 'prawn/layout'
#require 'prawn/format'


Prawn::Document.generate("multi_page_table.pdf") do

  table([%w[Some data in a table]] * 2)

end
