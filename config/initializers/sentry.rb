# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://294135d0007d437db4222b7bcb88e9c2@o4505546453811200.ingest.sentry.io/4505546455252992'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
