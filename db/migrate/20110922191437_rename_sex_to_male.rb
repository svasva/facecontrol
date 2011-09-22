class RenameSexToMale < ActiveRecord::Migration
  def up
  	rename_column :characters, :sex, :male
  end

  def down
  	rename_column :characters, :male, :sex
  end
end
