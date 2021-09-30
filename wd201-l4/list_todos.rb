require "./connect_db.rb"
require "./todo.rb"
connect_db!

#displayable_list = Todo.all.map { |todo| todo.to_displayable_string }
#puts displayable_list
#print Todo.to_displayable_list
Todo.show_list
