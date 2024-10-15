class LinkClickJob < ApplicationJob
  queue_as :default

  def perform(params)
    if params.is_a? Array
      params = params.each_with_index.map do |hash, index|
        hash.merge(id: LinkClickRepository.generate_id)
      end
    else
      params[:id] = LinkClickRepository.generate_id
    end

    LinkClickRepository.create(
      params
    )
  rescue StandardError => e
    puts "ERROR OCCURED WITH MESSAGE: #{e}"
  end
end
