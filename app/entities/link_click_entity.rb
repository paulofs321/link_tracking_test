

class LinkClickEntity < ApplicationEntity
  include ActiveModel::Model

  PREFIX = "link_click"

  attributes :id,
             :url,
             :anchor_text,
             :user_agent,
             :referrer,
             :ip_address,
             :created_at

  def to_partial_path
    "posts/link_click"  # The path to your partial
  end
end
