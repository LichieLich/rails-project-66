# frozen_string_literal: true

module CheckHelper
  def send_complete_notification(user, check)
    CheckNotificationMailer.with(
      user:,
      check:
    ).check_notification.deliver_later
  end

  def check_has_no_problems?(check)
    return false unless check.linter_result

    (check.linter_result[/offense_count":[^0]/] || check.linter_result[/errorCount":[^0]/] ||
      check.linter_result[/warningCount":[^0]/] || check.linter_result[/fixableErrorCount":[^0]/] ||
      check.linter_result[/fixableWarningCount":[^0]/]).nil?
  end
end
