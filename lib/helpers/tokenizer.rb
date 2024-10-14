# frozen_string_literal: true

module Helpers
  # Generates a token normally used in id of entities
  class Tokenizer
    def self.generate(prefix, repository)
      loop do
        id = "#{prefix}_#{SecureRandom.base58(24)}"

        break id unless repository.find(id)
      end
    end
  end
end
