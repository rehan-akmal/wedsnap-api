# app/controllers/api/v1/availabilities_controller.rb
module Api
    module V1
      class AvailabilitiesController < ApplicationController
        # GET /api/v1/availabilities
        def index
          avails = @current_user.availabilities
                               .page(params[:page])
                               .per(params[:per_page] || 20)
          render json: avails, each_serializer: AvailabilitySerializer
        end
  
        # GET /api/v1/availabilities/:id
        def show
          avail = @current_user.availabilities.find(params[:id])
          render json: AvailabilitySerializer.new(avail)
        end
  
        # POST /api/v1/availabilities
        def create
          avail = @current_user.availabilities.build(avail_params)
          if avail.save
            render json: AvailabilitySerializer.new(avail), status: :created
          else
            render json: { errors: avail.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT/PATCH /api/v1/availabilities/:id
        def update
          avail = @current_user.availabilities.find(params[:id])
          if avail.update(avail_params)
            render json: AvailabilitySerializer.new(avail)
          else
            render json: { errors: avail.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/availabilities/:id
        def destroy
          @current_user.availabilities.find(params[:id]).destroy
          head :no_content
        end
  
        private
  
        def avail_params
          params.require(:availability).permit(:day_of_week, :start_time, :end_time)
        end
      end
    end
  end
  