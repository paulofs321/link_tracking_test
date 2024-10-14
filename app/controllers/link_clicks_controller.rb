# frozen_string_literal: true

class LinkClicksController < ApplicationController
  rate_limit to: 5, within: 1.minute, only: :create,
            with: -> { redirect_to controller: :errors, action: :rate_limit_exceeded }
  skip_before_action :verify_authenticity_token
  wrap_parameters false

  def create
    LinkClickRepository.clear_cache

    LinkClickJob.perform_later(
      post_params.to_h
    )
  end

  private
    def post_params
      params.permit([ :url, :anchor_text, :referrer, :user_agent, :ip_address ])
    end
end
