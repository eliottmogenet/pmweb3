# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p "creating employers"

ledger = Employer.new(name: "Ledger")
ledger.save!

p "creating users"

john =  ledger.users.create(first_name: "John", last_name: "Lafleur", email: "test1@gmail.com", password: "test1@gmail.com")
john.save!

jack =  ledger.users.create(first_name: "Jack", last_name: "Sully", email: "test2@gmail.com", password: "test2@gmail.com")
jack.save!


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
