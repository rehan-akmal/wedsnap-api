# app/controllers/api/v1/packages_controller.rb
module Api
    module V1
      class PackagesController < ApplicationController
        before_action :set_gig, only: [:index, :create]
  
        # GET /api/v1/gigs/:gig_id/packages
        def index
          packages = @gig.packages.page(params[:page]).per(params[:per_page] || 20)
          render json: packages, each_serializer: PackageSerializer
        end
  
        # GET /api/v1/packages/:id
        def show
          package = Package.find(params[:id])
          render json: PackageSerializer.new(package)
        end
  
        # POST /api/v1/gigs/:gig_id/packages
        def create
          package = @gig.packages.build(package_params)
          if package.save
            render json: PackageSerializer.new(package), status: :created
          else
            render json: { errors: package.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT/PATCH /api/v1/packages/:id
        def update
          package = Package.find(params[:id])
          if package.update(package_params)
            render json: PackageSerializer.new(package)
          else
            render json: { errors: package.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/packages/:id
        def destroy
          Package.find(params[:id]).destroy
          head :no_content
        end
  
        private
  
        def set_gig
          @gig = Gig.find(params[:gig_id])
        end
  
        def package_params
          params.require(:package).permit(:name, :description, :price, :delivery_days, :revisions)
        end
      end
    end
  end
  