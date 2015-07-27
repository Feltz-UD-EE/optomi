class V5::AlertCategoriesController < ApplicationController
  def index
    render json: AlertCategory.select(:id, :name)
  end
end
