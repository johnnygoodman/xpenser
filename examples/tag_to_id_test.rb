require '../lib/xpenser'

xpenser_tag_array = Xpenser.get_all_tags
tag_id_array = []

def self.tag_id_to_name(tag_id_array, xpenser_tag_array)
   array = Array.new
   xpenser_tag_array.each do |tag|
     tag_id_array.each do |feedtag|
       if tag['id'] == feedtag['id']
       array << row['name'].to_s
     end
   end
   array
 end