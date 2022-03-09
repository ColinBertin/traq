class Users::LocationsController < ApplicationController
  def index
    @locations = policy_scope([:user, Location]).order(created_at: :desc)
  end
end
