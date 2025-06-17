# app/controllers/api/v1/gigs_controller.rb
module Api
    module V1
      class GigsController < ApplicationController
        skip_before_action :authorize_request, only: [:index, :show]
        # GET /api/v1/gigs
        def index
          gigs = Gig.includes(:user, :packages, :categories).page(params[:page]).per(params[:per_page] || 20)
          render json: gigs, each_serializer: Api::V1::GigSerializer
        end
  
        # GET /api/v1/gigs/:id
        def show
          gig = Gig.includes(:user, :packages, :features, :faqs, :categories).find(params[:id])
          render json: gig, serializer: Api::V1::GigSerializer
        end
  
        # POST /api/v1/gigs
        def create
          # Debug the incoming parameters
          Rails.logger.debug "Incoming params: #{params.inspect}"
          
          gig = @current_user.gigs.build(gig_params)
          
          # Handle categories
          if params[:gig][:category_ids].present?
            category_names = params[:gig][:category_ids]
            categories = category_names.map do |name|
              Category.find_or_create_by(name: name)
            end
            gig.categories = categories
          end
          
          # Debug the gig object before saving
          Rails.logger.debug "Gig before save: #{gig.attributes.inspect}"
          Rails.logger.debug "Packages: #{gig.packages.map(&:attributes).inspect}"
          Rails.logger.debug "Features: #{gig.features.map(&:attributes).inspect}"
          Rails.logger.debug "Faqs: #{gig.faqs.map(&:attributes).inspect}"
          
          if gig.save
            # Debug the saved gig
            Rails.logger.debug "Gig after save: #{gig.attributes.inspect}"
            Rails.logger.debug "Packages after save: #{gig.packages.map(&:attributes).inspect}"
            Rails.logger.debug "Features after save: #{gig.features.map(&:attributes).inspect}"
            Rails.logger.debug "Faqs after save: #{gig.faqs.map(&:attributes).inspect}"
            
            render json: gig, serializer: Api::V1::GigSerializer, status: :created
          else
            Rails.logger.error "Gig save errors: #{gig.errors.full_messages}"
            render json: { errors: gig.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT/PATCH /api/v1/gigs/:id
        def update
          gig = @current_user.gigs.find(params[:id])
          
          # Handle categories
          if params[:gig][:category_ids].present?
            category_names = params[:gig][:category_ids]
            categories = category_names.map do |name|
              Category.find_or_create_by(name: name)
            end
            gig.categories = categories
          end
          
          if gig.update(gig_params)
            render json: gig, serializer: Api::V1::GigSerializer
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
            :title, :description, :location, :phone_number,
            images: [],
            packages_attributes: [
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
  