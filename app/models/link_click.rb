# frozen_string_literal: true

require "resolv"

# Model class for link clicks
class LinkClick < ApplicationRecord
  validates :url, presence: true
  validates :url, format: { with: URI.regexp }
  validates :referrer, format: { with: URI.regexp }, allow_blank: true
  validates :ip_address, format: { with: /\A(?:\d{1,3}\.){3}\d{1,3}|\[?[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){0,7}\]?\z/ }

  PREFIX = "link_click"
end
