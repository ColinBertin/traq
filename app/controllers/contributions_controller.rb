class ContributionsController < ApplicationController
  def index
    @contributions = policy_scope(Contribution).order(created_at: :desc)
  end

  def new
  end

  def edit
  end
end
