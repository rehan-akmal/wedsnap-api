# app/controllers/api/v1/faqs_controller.rb
module Api
    module V1
      class FaqsController < ApplicationController
        before_action :set_gig, only: [:index, :create]
  
        # GET /api/v1/gigs/:gig_id/faqs
        def index
          faqs = @gig.faqs.page(params[:page]).per(params[:per_page] || 20)
          render json: faqs, each_serializer: FaqSerializer
        end
  
        # GET /api/v1/faqs/:id
        def show
          faq = Faq.find(params[:id])
          render json: FaqSerializer.new(faq)
        end
  
        # POST /api/v1/gigs/:gig_id/faqs
        def create
          faq = @gig.faqs.build(faq_params)
          if faq.save
            render json: FaqSerializer.new(faq), status: :created
          else
            render json: { errors: faq.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT/PATCH /api/v1/faqs/:id
        def update
          faq = Faq.find(params[:id])
          if faq.update(faq_params)
            render json: FaqSerializer.new(faq)
          else
            render json: { errors: faq.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/faqs/:id
        def destroy
          Faq.find(params[:id]).destroy
          head :no_content
        end
  
        private
  
        def set_gig
          @gig = Gig.find(params[:gig_id])
        end
  
        def faq_params
          params.require(:faq).permit(:question, :answer)
        end
      end
    end
  end
  