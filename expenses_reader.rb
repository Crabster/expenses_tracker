# include parser
require 'rexml/document'
# include date library
require 'date'

current_path = File.dirname(__FILE__ )
file_path = current_path + "/my_expenses.xml"

abort "Файл my_expenses.xml не найден" unless File.exist?(file_path)

file = File.new(file_path)

doc = REXML::Document.new(file)

amount_by_day = {}

doc.elements.each("expenses/expense") do |item|
  spend_summ = item.attributes["amount"].to_i
  spend_date = Date.parse(item.attributes["date"])

  amount_by_day[spend_date] ||= 0
  amount_by_day[spend_date] += spend_summ
end

file.close

sum_by_month = {}

current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

amount_by_day.keys.sort.each do |key|
  sum_by_month[key.strftime("%B %Y")] ||= 0
  sum_by_month[key.strftime("%B %Y")] += amount_by_day[key]
end

# titile for first month
puts "------ [ #{current_month}, total spend: #{sum_by_month[current_month]} roubles ] ------"

amount_by_day.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_month
    current_month = key.strftime("%B %Y")
    puts "------ [ #{current_month}, total spend: #{sum_by_month[current_month]} roubles ] ------"
  end
  puts "\t#{key.day}: #{amount_by_day[key]} roubles"
end