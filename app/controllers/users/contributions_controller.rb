class Users::ContributionsController < ApplicationController
  def index
    @contributions = policy_scope([:user, Contribution]).order(created_at: :desc)
  end
end
