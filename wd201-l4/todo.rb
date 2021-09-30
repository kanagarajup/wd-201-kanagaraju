require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def self.due_over
    where("due_date < ?", Date.today)
  end

  def self.due_today
    where("due_date = ?", Date.today)
  end

  def self.due_later
    where("due_date > ?", Date.today)
  end

  def to_displayable_string
    display_status = completed ? "[x]" : "[ ]"
    display_date = due_date == Date.today ? nil : due_date.to_s
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }.join("\n")
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts due_over.to_displayable_list
    puts "\n\n"

    puts "Due Today\n"
    puts due_today.to_displayable_list
    puts "\n\n"

    puts "Due Later\n"
    puts due_later.to_displayable_list
    puts "\n\n"
  end

  def self.add_task(todo_create)
    create!(todo_text: todo_create[:todo_text], due_date: Date.today + todo_create[:due_in_days], completed: false)
  end

  def self.mark_as_complete(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
