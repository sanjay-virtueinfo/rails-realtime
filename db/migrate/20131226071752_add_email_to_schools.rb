class AddEmailToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :email, :string, :after => :name
    add_column :schools, :owner, :string, :after => :email
    add_column :schools, :phone, :string, :after => :owner
    add_column :schools, :mobile, :string, :after => :phone
    add_column :schools, :country_id, :integer, :after => :city
  end
end
