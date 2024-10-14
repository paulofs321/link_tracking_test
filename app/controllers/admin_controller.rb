# frozen_string_literal: true

class AdminController < ApplicationController
  def index
    start_date = params[:start_date]
    end_date = params[:end_date]

    @clicks_per_link = LinkClickRepository.clicks_per_link(start_date, end_date)
    @total_link_clicks = LinkClickRepository.total_link_clicks(start_date, end_date)
    @clicks_over_time = LinkClickRepository.clicks_over_time(start_date, end_date)
    @most_clicked_link = LinkClickRepository.most_clicked_link
    @most_clicked_link_count = LinkClickRepository.most_clicked_link_count
  end
end
