# frozen_string_literal: true

module AuthHelper
  def signed_in?
    current_user.present?
  end
end
