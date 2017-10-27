class ExpertiseAreasController < ApplicationController
  def new
    @user = current_user
    @expertise_area = ExpertiseArea.where(parent_id: nil)
    @sub_expertise_area = ExpertiseArea.where(:parent_id.not_eq => nil)
  end

  def create
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
  end

  def show
  end
end
