class AddGenderAndFirstNameAndLastNameAndYearBornAndUniversityYearAndOccupationAndStudyingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :integer
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :year_born, :integer
    add_column :users, :university_year, :integer
    add_column :users, :occupation, :integer
    add_column :users, :studying, :string
  end
end
