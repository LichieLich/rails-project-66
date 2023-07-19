# frozen_string_literal: true

module Web
  class ApplicationController < ActionController::Base
    def current_user
      # include Pundit::Authorization

      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
