# app/controllers/api/v1/availabilities_controller.rb
module Api
    module V1
      class AvailabilitiesController < ApplicationController
        before_action :set_availability, only: [:show, :update, :destroy]
  
        # GET /api/v1/availabilities
        def index
          avails = @current_user.availabilities
                               .ordered_by_date
                               .page(params[:page])
                               .per(params[:per_page] || 50)
          render json: avails.map { |avail| serialize_availability(avail) }
        end
  
        # GET /api/v1/availabilities/:id
        def show
          render json: serialize_availability(@availability)
        end
  
        # POST /api/v1/availabilities
        def create
          # Check if availability already exists for this date
          existing_availability = @current_user.availabilities.find_by(date: avail_params[:date])
          
          if existing_availability
            # Update existing availability
            if existing_availability.update(avail_params)
              render json: serialize_availability(existing_availability)
            else
              render json: { errors: existing_availability.errors.full_messages }, status: :unprocessable_entity
            end
          else
            # Create new availability
            avail = @current_user.availabilities.build(avail_params)
            if avail.save
              render json: serialize_availability(avail), status: :created
            else
              render json: { errors: avail.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end
  
        # PUT/PATCH /api/v1/availabilities/:id
        def update
          if @availability.update(avail_params)
            render json: serialize_availability(@availability)
          else
            render json: { errors: @availability.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/availabilities/:id
        def destroy
          @availability.destroy
          head :no_content
        end
  
        # GET /api/v1/availabilities/check/:date
        def check
          date = params[:date]
          availability = @current_user.availabilities.find_by(date: date)
          
          if availability
            render json: { 
              date: date, 
              available: availability.is_available,
              exists: true 
            }
          else
            render json: { 
              date: date, 
              available: true, # Default to available
              exists: false 
            }
          end
        end
  
        private
  
        def set_availability
          @availability = @current_user.availabilities.find(params[:id])
        end
  
        def avail_params
          params.require(:availability).permit(:date, :is_available)
        end
  
        def serialize_availability(availability)
          {
            id: availability.id,
            date: availability.date.strftime('%Y-%m-%d'),
            available: availability.is_available,
            created_at: availability.created_at,
            updated_at: availability.updated_at
          }
        end
      end
    end
  end
  