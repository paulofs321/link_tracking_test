# frozen_string_literal: true

require "resolv"

# Model class for link clicks
class LinkClick < ApplicationRecord
  validates :url, presence: true
  validates :url, format: { with: URI.regexp }
  validates :referrer, format: { with: URI.regexp }, allow_blank: true
  validates :ip_address, format: { with: Resolv::IPv4::Regex }
end
