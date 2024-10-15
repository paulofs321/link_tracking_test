# frozen_string_literal: true

# Parent class of all repositories

class ApplicationRepository
  def initialize(model)
    @model = model
  end

  class << self
    def all
      model.all
    end

    def find(id)
      model.find(id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def create(data)
      if data.is_a? Array
        symobolized_data = data.map(&:symbolize_keys)

        records = model.create!(symobolized_data)

        records
      else
        record = model.create!(data.symbolize_keys)

        record
      end
    end

    def update(id, params)
      record = @model.find(id)
      if record.update(params)
        record
      else
        nil
      end
    end

    def destroy(id)
      @model.find(id).destroy
    end

    def generate_id
      Helpers::Tokenizer.generate(model::PREFIX, self)
    end

    private

    def base_class
      name.gsub(/Repository/, "")
    end
  end
end
