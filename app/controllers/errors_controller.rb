# frozen_string_literal: true

class ErrorsController < ApplicationController
  def rate_limit_exceeded
    render status: 429
  end

  def internal_server_error
    render status: 500
  end
end
