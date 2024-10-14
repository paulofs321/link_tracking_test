class CreateLinkClicks < ActiveRecord::Migration[8.0]
  def change
    create_table :link_clicks, id: false do |t|
      t.string :id, primary_key: true
      t.string :url, null: false, index: true # the full URL of the clicked link
      t.string :anchor_text # the text content of the clicked link)
      t.string :referrer # the page URL where the click originated)
      t.string :user_agent # the user's browser information)
      t.string :ip_address # the user's IP address)

      t.datetime :created_at, index: true
    end
  end
end
