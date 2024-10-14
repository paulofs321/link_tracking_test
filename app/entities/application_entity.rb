# frozen_string_literal: true

# Parent class of all entities
class ApplicationEntity
  def self.attributes(*attributes)
    @attribute_list = attributes.each do |attribute|
      attr_accessor attribute
    end
  end

  class << self
    attr_reader :attribute_list
  end
end
