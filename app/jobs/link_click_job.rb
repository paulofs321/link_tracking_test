class LinkClickJob < ApplicationJob
  queue_as :default

  def perform(params)
    params[:id] = LinkClickRepository.generate_id

    LinkClickRepository.create(
      params
    )
  rescue StandardError => e
    puts "ERROR OCCURED WITH MESSAGE: #{e}"
  end
end
