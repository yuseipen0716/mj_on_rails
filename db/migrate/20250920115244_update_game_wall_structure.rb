class UpdateGameWallStructure < ActiveRecord::Migration[8.0]
  def change
    remove_column :games, :wall, :text
    add_column :games, :main_wall, :text
    add_column :games, :locked_wall, :text
  end
end
