require 'rexml/document'
require 'date'

puts 'Какой товар был приобретен?'
expense_text = STDIN.gets.strip

puts 'Какое количество денежных средств было потрачено?'
expense_amount = STDIN.gets.to_i

puts 'Когда была произведена покупка? (укажите дату в формате ДД.ММ.ГГГГ, ' \
  'например 02.06.2020, пустое поле - сегодня)'
date_input = STDIN.gets.chomp

if date_input == ''
  expense_date = Date.today
else
  begin
    expense_date = Date.parse(date_input)
  rescue ArgumentError
    expense_date = Date.today
  end
end

puts 'В какую категорию внести трату'
expense_category = STDIN.gets.chomp

current_path = File.dirname(__FILE__)
file_name = current_path + '/my_expenses.xml'
file = File.new(file_name, 'r:UTF-8')
begin
  doc = REXML::Document.new(file)
rescue REXML::ParseException => e
  puts 'XML файл протух :('
  abort e.message
end
file.close

expenses = doc.elements.find('expenses').first

expense = expenses.add_element 'expense', {
  'date' => expense_date.strftime('%Y.%m.%d'),
  'category' => expense_category,
  'amount' => expense_amount
}

expense.text = expense_text

file = File.new(file_name, "w:UTF-8")
doc.write(file, 3)
file.close

puts 'Запись прошла успешно'