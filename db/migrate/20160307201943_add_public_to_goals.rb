class AddPublicToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :public, :boolean
  end
end
