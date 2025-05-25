# app/controllers/api/v1/features_controller.rb
module Api
    module V1
      class FeaturesController < ApplicationController
        before_action :set_gig, only: [:index, :create]
  
        # GET /api/v1/gigs/:gig_id/features
        def index
          features = @gig.features.page(params[:page]).per(params[:per_page] || 20)
          render json: features, each_serializer: FeatureSerializer
        end
  
        # GET /api/v1/features/:id
        def show
          feature = Feature.find(params[:id])
          render json: FeatureSerializer.new(feature)
        end
  
        # POST /api/v1/gigs/:gig_id/features
        def create
          feature = @gig.features.build(feature_params)
          if feature.save
            render json: FeatureSerializer.new(feature), status: :created
          else
            render json: { errors: feature.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT/PATCH /api/v1/features/:id
        def update
          feature = Feature.find(params[:id])
          if feature.update(feature_params)
            render json: FeatureSerializer.new(feature)
          else
            render json: { errors: feature.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/features/:id
        def destroy
          Feature.find(params[:id]).destroy
          head :no_content
        end
  
        private
  
        def set_gig
          @gig = Gig.find(params[:gig_id])
        end
  
        def feature_params
          params.require(:feature).permit(:name)
        end
      end
    end
  end
  