# app/controllers/api/v1/categories_controller.rb
module Api
    module V1
      class CategoriesController < ApplicationController
        skip_before_action :authorize_request, only: [:index, :show]
  
        # GET /api/v1/categories
        def index
          cats = Category.all
          render json: cats, each_serializer: CategorySerializer
        end
  
        # GET /api/v1/categories/:id
        def show
          cat = Category.find(params[:id])
          render json: CategorySerializer.new(cat)
        end
      end
    end
  end
  