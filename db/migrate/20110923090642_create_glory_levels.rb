class CreateGloryLevels < ActiveRecord::Migration
  def change
    create_table :glory_levels do |t|
      t.integer :level
      t.integer :glory
      t.integer :max_energy

      t.timestamps
    end
  end
end
