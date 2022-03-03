class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @contributions = Contribution.all
    # @client_ip = remote_ip
    # @results = Geocoder.search("172.56.21.89")
    # @results = @results.first.coordinates
  end
end
