module Api
  module V1
    class DashboardController < ApplicationController

      def seller_stats
        user = @current_user
        
        stats = {
          views: {
            total: user&.profile_views_count || 0,
            this_month: user&.profile_views_count_this_month || 0
          },
          earnings: {
            total: user&.total_earnings || 0,
            this_month: user&.earnings_this_month || 0
          },
          orders: {
            total: user&.orders_count || 0,
            completed: user&.completed_orders_count || 0,
            in_progress: user&.in_progress_orders_count || 0
          },
          reviews: {
            total: user&.reviews_count || 0,
            average_rating: user&.average_rating || 0
          }
        }

        render json: stats
      end

      def buyer_stats
        user = @current_user
        
        stats = {
          orders: {
            total: user&.orders_count || 0,
            completed: user&.completed_orders_count || 0,
            in_progress: user&.in_progress_orders_count || 0
          },
          saved_gigs: user&.saved_gigs_count || 0,
          reviews_given: user&.reviews_given_count || 0
        }

        render json: stats
      end

      def overview
        user = @current_user
        
        render json: {
          total_gigs: user&.gigs&.count || 0,
          active_gigs:  user&.gigs&.count|| 0,
        }
      end
    end
  end
end 