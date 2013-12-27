# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create a admin user
puts '==================================================================='
puts 'Load super admin'
puts '==================================================================='
@admin = User.new(:last_name => 'admin', :first_name => 'admin', :password => 'password', :password_confirmation => 'password', :email => 'admin@example.com', :is_active => 1, :term => true)
@admin.save(:validate => false)

puts '==================================================================='
puts 'Load roles'
puts '==================================================================='
# Create a role type for users
@admin_role = Role.create(:role_type => "SuperAdmin")
Role.create(:role_type => "User")

puts '==================================================================='
puts 'Load user roles'
puts '==================================================================='
# Create a role type for users
@admin.role = @admin_role
