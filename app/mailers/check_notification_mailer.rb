# frozen_string_literal: true

class CheckNotificationMailer < ApplicationMailer
  def check_notification
    @user = params[:user]
    @check = params[:check]

    mail(to: @user.email, subject: t('.subject', repository_name: @check.repository.name))
  end
end
