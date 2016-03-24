require "active_record"
require "yaml"
require "pry"

require "databasics/version"
require "databasics/user"
require "databasics/address"
require "databasics/order"
require "databasics/item"

db_config = YAML.load(File.open("config/database.yml"))
ActiveRecord::Base.establish_connection(db_config)

module Databasics
  class App
    def initialize
      @first_name = nil
      @last_name = nil
      @email = nil
    end

    def set_user
      puts "Enter your first name:"
      @first_name = gets.chomp
      puts "Enter your last name:"
      @last_name = gets.chomp
      puts "Enter your e-mail"
      @email = gets.chomp
    end

    def create_user
      set_user
      Databasics::User.find_or_create_by(first_name: @first_name,
      last_name: @last_name, email: @email)
      user = Databasics::User.last
      puts "User: #{user.id}, #{user.first_name} #{user.last_name}, #{user.email}"
    end

    def get_address
      puts "Enter user id:"
      user_id = gets.chomp.to_i
      user = Databasics::User.find(user_id)
      addresses = Databasics::Address.where(user_id: user.id)
      addresses.each do |address|
        puts "Address: #{address.street}, #{address.city}, #{address.state}"
      end
    end

    def display_orders
      puts "what is your ID?"
      user_id = gets.chomp.to_i
      user = Databasics::User.find(user_id)
      orders = Databasics::Order.where(user_id: user.id)
      orders.each do |order|
        item = Databasics::Item.find(order.item_id)
        puts "you ordered #{order.quantity} #{item.title.pluralize}"
      end
    end

    def create_order
      puts "what is your ID?"
      user_id = gets.chomp.to_i
      puts "enter the item ID of the item you wish to order:"
      item_id = gets.chomp.to_i
      puts "enter the quantity of the item:"
      quantity = gets.chomp.to_i
      user = Databasics::User.find(user_id)
      name = "#{user.first_name} #{user.last_name}"
      item = Databasics::Item.find(item_id)
      orders = Databasics::Order.create(user_id: user.id, item_id: item.id,
      quantity: quantity)
      puts "order id: #{orders.id}"
      puts "user id: #{orders.user_id}, user name: #{name}"
      puts "item id: #{orders.item_id}, item name: #{item.title}"
      puts "quantity: #{orders.quantity}, date: #{orders.created_at}"
    end
  ## 3 ActiveRecord querying methods
  # 1) Model.where
  # 2) Model.find
  # 3) Model.find_by
  end
end

app = Databasics::App.new
app.create_user
app.get_address
app.display_orders
app.create_order
