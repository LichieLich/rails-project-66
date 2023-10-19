# frozen_string_literal: true

module CheckHelper
  def send_complete_notification(user, check)
    CheckNotificationMailer.with(
      user:,
      check:
    ).check_notification.deliver_later
  end
end
