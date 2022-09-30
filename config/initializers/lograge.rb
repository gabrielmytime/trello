# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge_#{Rails.env}.log"
end
