# frozen_string_literal: true

class LinkClicksController < ApplicationController
  rate_limit to: 5, within: 1.minute, only: :create,
             with: -> { redirect_to controller: :errors, action: :rate_limit_exceeded }
  skip_before_action :verify_authenticity_token

  def create
    LinkClickRepository.clear_cache(cache_keys_to_delete)

    LinkClickJob.perform_later(
      post_params
    )
  end

  private
    def post_params
      if params[:link_click].present?
        return params.require(:link_click).permit([ :url, :anchor_text, :referrer, :user_agent ]).to_h.merge(ip_address: request.remote_ip)
      end

      json_params = []

      # Ensure _json is an array and permit its parameters
      if params[:_json].present?
        params[:_json].each do |json_hash|
          permitted_params = json_hash.permit([ :url, :anchor_text, :referrer, :user_agent ]).to_h.merge(ip_address: request.remote_ip)
          json_params << permitted_params
        end
      end

      json_params
    end

    def cache_keys_to_delete
      cache_keys = Rails.cache.instance_variable_get(:@data).keys

      cache_keys.map do |k, v|
        k if k.include? "#{Date.today}"
      end
    end
end
