# frozen_string_literal: true

class ErrorsController < ApplicationController
  def rate_limit_exceeded
    render status: 429
  end
end
