# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

daemon = User.new(id: 0, login_id: "daemon", password: 'password', name: 'Daemon', description: '')
daemon.save!

admin = User.new(id: 1, login_id: "admin", password: 'password', name: 'Admin', description: '')
admin.save!

anonym = User.new(id: 2, login_id: "anonym", password: 'password', name: '', description: '')
anonym.save!

permission = Admin.new(user_id: 1, permission: 15)
permission.save!

root = Tweet.new(id: 0, user_id: 0, parent_id: 0, content: 'root')
root.save!
