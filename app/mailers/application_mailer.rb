# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'awesome_check_notifier@example.com'
  layout 'mailer'
end
