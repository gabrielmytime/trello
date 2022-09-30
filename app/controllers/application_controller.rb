# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_404

  def error_404
    render json: {}, status: :not_found
  end
end
