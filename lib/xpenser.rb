require 'rubygems'
require 'httparty'
require 'prawn'
require 'prawn/layout'
require 'faster_csv'
require 'pp'
require '../config/passwords.rb'
require 'mongo_mapper'
require 'hashie'
require 'hashie/mash'

class Expense
  
  include MongoMapper::Document
  key :expense_id, ObjectId
  key :amount, Integer
  key :date, Time
  key :notes, String
  key :tags, Array
  key :category, Array

end

class Xpenser
  
  include HTTParty
  base_uri 'http://xpenser.com'
  basic_auth XPENSER[:username], XPENSER[:password]
  default_params :format => 'json'
  format :json

  # Public: Initialize a httparty instance with xpenser.com.
  #
  # user  - The String username.
  # pass  - The String password.
  #
  # Examples
  #
  #   initialize('my.xpenser@username.com', 'myxpenserpassword')
  #   # => 'Unsure...what does the initialize return?'
  #
  # Returns the duplicated String.
  def initialize(user, pass)
    self.class.basic_auth user, pass
  end

  # Public: Get all expenses for the default report. 
  #
  # Examples
  #
  #   pp Class.get_default_report 
  #   # => #<Expense category: [36677], notes: "UpsellIt.com - 5% of July's Upsellit Generated Sales", 
  #         amount: 2131, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000066'), tags: [], 
  #         date: Sat Jul 31 14:04:00 UTC 2010, type: "Web Software Rental">,
  #         <Expense category: [36675], notes: "Endicia.com - US Mail Shipments Conf 161474", 
  #          amount: 400, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000001'), tags: [], 
  #          date: Wed Aug 25 21:43:45 UTC 2010, type: "Freight">
  #
  # Returns HTTParty::Response Object. 
  def self.get_default_report_expenses
    get("/api/expenses/")
  end
  
  # Public: Get all expenses for a single report.
  #
  # report_id  - The Integer of the report you want returned. 
  #
  # Examples
  #
  #   pp Class.get_default_report(report_id)
  # 
  #   # => #<Expense category: [36677], notes: "UpsellIt.com - 5% of July's Upsellit Generated Sales", 
  #         amount: 2131, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000066'), tags: [], 
  #         date: Sat Jul 31 14:04:00 UTC 2010, type: "Web Software Rental">,
  #         <Expense category: [36675], notes: "Endicia.com - US Mail Shipments Conf 161474", 
  #          amount: 400, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000001'), tags: [], 
  #          date: Wed Aug 25 21:43:45 UTC 2010, type: "Freight">
  #
  # Returns HTTParty::Response Object.
  def self.get_report(report_id)
    get("/api/v1.0/ expenses/?report=#{report_id}")
  end
  
  # Public: Get all expenses for all reports.
  #
  # Examples
  #
  #   pp Class.get_default_report 
  #
  #   # => #<Expense category: [36677], notes: "UpsellIt.com - 5% of July's Upsellit Generated Sales", 
  #         amount: 2131, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000066'), tags: [], 
  #         date: Sat Jul 31 14:04:00 UTC 2010, type: "Web Software Rental">,
  #         <Expense category: [36675], notes: "Endicia.com - US Mail Shipments Conf 161474", 
  #          amount: 400, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000001'), tags: [], 
  #          date: Wed Aug 25 21:43:45 UTC 2010, type: "Freight">
  #
  # Returns HTTParty::Response Object.
  def self.get_all_reports
    get("/api/v1.0/expenses/?report=*")
  end
  
  def self.get_all_reports_with_date(date)
    get("/api/v1.0/expenses/?report=*&date_op=gt&date=#{date}")
  end
  
  def self.get_all_tags
    get("/api/v1.0/tags/")    
  end
  
  
  # Public: 
  #
  # Examples
  #
  #   pp Class.get_default_report 
  #
  #   # => #<Expense category: [36677], notes: "UpsellIt.com - 5% of July's Upsellit Generated Sales", 
  #         amount: 2131, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000066'), tags: [], 
  #         date: Sat Jul 31 14:04:00 UTC 2010, type: "Web Software Rental">,
  #         <Expense category: [36675], notes: "Endicia.com - US Mail Shipments Conf 161474", 
  #          amount: 400, expense_id: nil, _id: BSON::ObjectID('4c7921426cd1692525000001'), tags: [], 
  #          date: Wed Aug 25 21:43:45 UTC 2010, type: "Freight">
  #
  # Returns HTTParty::Response Object.  
  def self.tag_to_name(tag_id_array, xpenser_tag_array) # returns array
    array = Array.new
    xpenser_tag_array.each do |row|
      if row['id'] == tag_id
        array << row['name'].to_s
      end
    end
    array
  end
  
end