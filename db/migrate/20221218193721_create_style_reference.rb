class CreateStyleReference < ActiveRecord::Migration[7.0]
  def change
    add_reference :beers, :style
  end
end
