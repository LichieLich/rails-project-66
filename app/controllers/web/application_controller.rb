# frozen_string_literal: true

module Web
  class ApplicationController < ActionController::Base
    include Pundit::Authorization
    include AuthConcern

    rescue_from Pundit::NotAuthorizedError do
      redirect_to :root, alert: t('navigation.errors.no_access')
    end
  end
end
