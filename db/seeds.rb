# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

Employer.destroy_all
User.destroy_all
Project.destroy_all
Task.destroy_all

p "creating employers"

ledger = Employer.new(name: "Ledger")
ledger.save!

p "creating users"

john =  ledger.users.create(first_name: "John", last_name: "Lafleur", email: "test1@gmail.com", password: "test1@gmail.com")
john.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/john.png')), filename: 'john.png')
john.save!

jack =  ledger.users.create(first_name: "Jack", last_name: "Sully", email: "test2@gmail.com", password: "test2@gmail.com")
jack.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/jack.png')), filename: 'jack.png')
jack.save!

emilie =  ledger.users.create(first_name: "Emily", last_name: "Simpson", email: "test3@gmail.com", password: "test3@gmail.com")
emilie.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/emily.png')), filename: 'emily.png')
emilie.save!

simon =  ledger.users.create(first_name: "Simon", last_name: "Dupuis", email: "test4@gmail.com", password: "test4@gmail.com")
simon.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/simon.png')), filename: 'simon.png')
simon.save!

jessica =  ledger.users.create(first_name: "Jessica", last_name: "Dounia", email: "test5@gmail.com", password: "test5@gmail.com")
jessica.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/jessica.png')), filename: 'jessica.png')
jessica.save!

sylvain =  ledger.users.create(first_name: "Sylvain", last_name: "Meunier", email: "test6@gmail.com", password: "test6@gmail.com")
sylvain.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/sylvain.png')), filename: 'sylvain.png')
sylvain.save!

sonia =  ledger.users.create(first_name: "Sonia", last_name: "Karini", email: "test7@gmail.com", password: "test7@gmail.com")
sonia.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/sonia.png')), filename: 'sonia.png')
sonia.save!

remy =  ledger.users.create(first_name: "Remy", last_name: "Dupon", email: "test8@gmail.com", password: "test8@gmail.com")
remy.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/remy.png')), filename: 'remy.png')
remy.save!

justin =  ledger.users.create(first_name: "Justin", last_name: "Vogel", email: "test9@gmail.com", password: "test9@gmail.com")
justin.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/justin.png')), filename: 'justin.png')
justin.save!

eliott =  ledger.users.create(first_name: "Eliott", last_name: "Mogenet", email: "test10@gmail.com", password: "test10@gmail.com")
eliott.photo.attach(io: File.open(File.join(Rails.root,'app/assets/images/eliott.png')), filename: 'eliott.png')
eliott.save!



p "creating projects"

project1 = john.projects.create(name: "Redesign website", employer_id: ledger.id)
project1.save!


project2 = jack.projects.create(name: "Reach 500 users", employer_id: ledger.id)
project2.save!

p "creating tasks"

task1 = project1.tasks.create(title: "Build prototype on Figma", status: "On Going", token_number: "10", user_id: john.id)
task1.save!

task2 = project1.tasks.create(title: "Code Backend", status: "On Going", token_number: "10", user_id: jack.id)
task2.save!


task3 = project2.tasks.create(title: "Build growth strategy", status: "On Going", token_number: "10", user_id: john.id)
task3.save!

task4 = project2.tasks.create(title: "Create community", status: "On Going", token_number: "10", user_id: jack.id)
task4.save!

p "finished"
