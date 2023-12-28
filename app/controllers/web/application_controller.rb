# frozen_string_literal: true

module Web
  class ApplicationController < ActionController::Base
    include Pundit::Authorization

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    rescue_from Pundit::NotAuthorizedError do
      redirect_to :root, alert: t('navigation.errors.no_access')
    end
  end
end
