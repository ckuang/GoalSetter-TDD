class RenamePublicColumnForGoals < ActiveRecord::Migration
  def change
    rename_column :goals, :public, :visibility
  end
end
