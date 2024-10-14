class AddIndexToLinkClicks < ActiveRecord::Migration[8.0]
  def change
    add_index :link_clicks, [ :url, :created_at ]
  end
end
