class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index terms privacy ]

  def index
    @campaigns = Campaign.where(status: true)
  end

  def terms
  end

  def privacy
  end
end
