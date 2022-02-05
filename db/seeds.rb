# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

Employer.destroy_all
Task.destroy_all
User.destroy_all
Project.destroy_all
Topic.destroy_all
ProjectUser.destroy_all


p "creating users"

john =  User.create(first_name: "John", last_name: "Lafleur", email: "test1@gmail.com", password: "test1@gmail.com", pseudo: 'Fire1')
john.save!

jack =  User.create(first_name: "Jack", last_name: "Sully", email: "test2@gmail.com", password: "test2@gmail.com", pseudo: 'Fire2')
jack.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/jack.png')), filename: 'jack.png')
jack.save!

emilie =  User.create(first_name: "Emily", last_name: "Simpson", email: "test3@gmail.com", password: "test3@gmail.com")
emilie.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/emily.png')), filename: 'emily.png')
emilie.save!

simon =  User.create(first_name: "Simon", last_name: "Dupuis", email: "test4@gmail.com", password: "test4@gmail.com")
simon.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/simon.png')), filename: 'simon.png')
simon.save!

jessica =  User.create(first_name: "Jessica", last_name: "Dounia", email: "test5@gmail.com", password: "test5@gmail.com")
jessica.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/jessica.png')), filename: 'jessica.png')
jessica.save!

sylvain =  User.create(first_name: "Sylvain", last_name: "Meunier", email: "test6@gmail.com", password: "test6@gmail.com")
sylvain.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/sylvain.png')), filename: 'sylvain.png')
sylvain.save!

sonia =  User.create(first_name: "Sonia", last_name: "Karini", email: "test7@gmail.com", password: "test7@gmail.com")
sonia.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/sonia.png')), filename: 'sonia.png')
sonia.save!

remy =  User.create(first_name: "Remy", last_name: "Dupon", email: "test8@gmail.com", password: "test8@gmail.com")
remy.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/remy.png')), filename: 'remy.png')
remy.save!

justin =  User.create(first_name: "Justin", last_name: "Vogel", email: "test9@gmail.com", password: "test9@gmail.com")
justin.photo.attach(io: File.open(File.join(Rails.root,'db/fixtures/justin.png')), filename: 'justin.png')
justin.save!

eliott = User.create(first_name: "Eliott", last_name: "Mogenet", email: "eliott.mogenet@gmail.com", password: "eliott.mogenet@gmail.com")
eliott.save!

p "creating projects and assign a manager/creator"

project1 = Project.create(name: "Safary", user_id: john.id, description: "Safary is a community to learn about growth")
project1.save!


project2 = Project.create(name: "Pianity", user_id: jack.id)
project2.save!

p "creating user_projects and project members by this way"

project_user1 = remy.project_users.create(project_id: project1.id)
project_user1.save!

project_user2 = eliott.project_users.create(project_id: project1.id)
project_user2.save!

project_user3 = jack.project_users.create(project_id: project2.id)
project_user3.save!


p "creating topics"

topic1 = project1.topics.create(name: "New" , description: "It a new topic", rules: "Viva los rules", can_create_task: true, can_assign_task: false, can_vote: true)
topic1.save!


topic2 = project1.topics.create(name: "Event" , description: "It's the event topic", rules: "Viva los rules" )
topic2.save!


p "creating tasks"

task1 = project1.tasks.create(title: "Build prototype on Figma", token_number: "10", creator_id: eliott.id, confidentiality: "Private", topic_id: topic1.id )
task1.save!

task2 = project1.tasks.create(title: "Code Backend", status: "ongoing", token_number: "10", user_id: jack.id, creator_id: justin.id, confidentiality: "Public", topic_id: topic2.id)
task2.save!


task3 = project1.tasks.create(title: "Build growth strategy", status: "ongoing", token_number: "10", user_id: john.id, creator_id: remy.id, confidentiality: "Public", topic_id: topic2.id)
task3.save!

task4 = project1.tasks.create(title: "Create community", status: "ongoing", token_number: "10", user_id: jack.id, creator_id: sonia.id, confidentiality: "Public", topic_id: topic2.id)
task4.save!

p "create tasks"

vote1 = task1.votes.create(user_id: eliott.id)
vote1.save!


p "finished"
