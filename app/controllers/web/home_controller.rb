# frozen_string_literal: true

module Web
  class HomeController < ApplicationController
    def index
      @bash = BashRunner.run('echo 12312312')
    end
  end
end
