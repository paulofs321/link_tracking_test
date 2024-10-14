# frozen_string_literal: true

# Parent class of all repositories

class ApplicationRepository
  def initialize(model)
    @model = model
  end

  class << self
    def all
      model.all.map { |record| create_entity(record) }
    end

    def find(id)
      record = model.find(id)
      create_entity(record) if record
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def create(data)
      if data.is_a? Array
        symobolized_data = data.map(&:symbolize_keys)

        records = model.create!(symobolized_data)

        records.map do |record|
          create_entity(record)
        end
      else
        record = model.create!(data.symbolize_keys)

        create_entity(record)
      end
    end

    def update(id, params)
      record = @model.find(id)
      if record.update(params)
        create_entity(record)
      else
        nil
      end
    end

    def destroy(id)
      @model.find(id).destroy
    end

    def generate_id
      Helpers::Tokenizer.generate(entity_class::PREFIX, self)
    end

    private

    def base_class
      name.gsub(/Repository/, "")
    end

    def create_entity(record)
      entity_class.new(record.attributes.symbolize_keys)
    end

    def entity_class
      Object.const_get("#{base_class}Entity")
    end
  end
end
