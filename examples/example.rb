require '../lib/xpenser'

#json_string = ""
 
#req = open("http://xpenser.com/api/expenses/?format=json", :http_basic_authentication=>['johnny.goodman@gmail.com', 'wef98wam'])
#req.each_line {|line| json_string << line}

 

fields_pairs = Array.new


Net::HTTP.start('www.xpenser.com') do |http|
  req = Net::HTTP::Get.new('http://xpenser.com/api/expenses/?format=json')
  #req = Net::HTTP::Get.new('http://xpenser.com/api/v1.0/report/87396')
  req.basic_auth XPENSER[:username], XPENSER[:password]
  response = http.request(req)
  #json = response.body
  array = Crack::JSON.parse(response.body)
    
    
  array.each do |row|
      row['fields'].each_pair do |k,v|
        puts "#{k} is #{v}"
      end
      break
  end
 
 
end 


# fields_pairs << h.select { |k, v|  k == "fields" }
#  fields_pairs.each


=begin    
    hash.each_ do |k|
      puts hash.fetch("#{k}")
    end
=end
