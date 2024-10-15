# frozen_string_literal: true

# Link Click repository
class LinkClickRepository < ApplicationRepository
  def self.model
    LinkClick
  end

  def self.clicks_over_time(start_date = "", end_date = "")
    start_date = start_date.present? ? Date.parse(start_date).to_datetime.beginning_of_day : nil
    end_date = end_date.present? ? Date.parse(end_date).to_datetime.end_of_day : Date.today.to_datetime.end_of_day

    cache_key = "clicks_over_time/#{start_date}-#{end_date}"

    @clicks_over_time = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      if start_date
        model
        .where(created_at: start_date..end_date)
        .group("DATE(created_at)")
        .count
      else
        model
        .where("created_at <= ?", end_date)
        .group("DATE(created_at)")
        .count
      end
    end
  end

  def self.clicks_per_link(start_date = "", end_date = "")
    start_date = start_date.present? ? Date.parse(start_date).to_datetime.beginning_of_day : nil
    end_date = end_date.present? ? Date.parse(end_date).to_datetime.end_of_day : Date.today.to_datetime.end_of_day

    cache_key = "clicks_per_link/#{start_date}-#{end_date}"

    @clicks_per_link = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      if start_date
        model
        .where(created_at: start_date..end_date)
        .group(:url)
        .order("count_id DESC")
        .count(:id)
      else
        model
        .where("created_at <= ?", end_date)
        .group(:url)
        .order("count_id DESC")
        .count(:id)
      end
    end
  end

  def self.most_clicked_link
    return nil if @clicks_per_link.empty?

    @clicks_per_link.first[0]
  end

  def self.most_clicked_link_count
    return 0 if @clicks_per_link.empty?

    @clicks_per_link.first[1]
  end

  def self.total_link_clicks(start_date = "", end_date = "")
    start_date = start_date.present? ? Date.parse(start_date).to_datetime.beginning_of_day : nil
    end_date = end_date.present? ? Date.parse(end_date).to_datetime.end_of_day : Date.today.to_datetime.end_of_day

    cache_key = "total_link_clicks/#{start_date}-#{end_date}"

    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      if start_date
        model
        .where(created_at: start_date..end_date)
        .count
      else
        model
        .where("created_at <= ?", end_date)
        .count
      end
    end
  end

  def self.clear_cache(keys_to_delete)
    keys_to_delete.each do |key|
      Rails.cache.delete(key) unless key.nil?
    end
  end
end
