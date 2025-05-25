# app/controllers/api/v1/gigs_controller.rb
module Api
    module V1
      class GigsController < ApplicationController
        skip_before_action :authorize_request, only: [:index]
        # GET /api/v1/gigs
        def index
          gigs = Gig.page(params[:page]).per(params[:per_page] || 20)
          render json: gigs, each_serializer: Api::V1::GigSerializer
        end
  
        # GET /api/v1/gigs/:id
        def show
          gig = Gig.find(params[:id])
          render json: GigSerializer.new(gig)
        end
  
        # POST /api/v1/gigs
        def create
          gig = @current_user.gigs.build(gig_params)
          if gig.save
            render json: GigSerializer.new(gig), status: :created
          else
            render json: { errors: gig.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT/PATCH /api/v1/gigs/:id
        def update
          gig = @current_user.gigs.find(params[:id])
          if gig.update(gig_params)
            render json: GigSerializer.new(gig)
          else
            render json: { errors: gig.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/gigs/:id
        def destroy
          @current_user.gigs.find(params[:id]).destroy
          head :no_content
        end
  
        private
  
        def gig_params
          params.require(:gig).permit(
            :title, :description, :location, :image,
            category_ids: [],            # for assigning many-to-many
            packages_attributes: [       # if you allow nested creation
              :id, :name, :description, :price, :delivery_days, :revisions, :_destroy
            ],
            features_attributes: [
              :id, :name, :_destroy
            ],
            faqs_attributes: [
              :id, :question, :answer, :_destroy
            ]
          )
        end
      end
    end
  end
  