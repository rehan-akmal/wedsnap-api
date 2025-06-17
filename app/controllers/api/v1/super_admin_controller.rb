module Api
  module V1
    class SuperAdminController < ApplicationController
      before_action :ensure_super_admin!

      # Dashboard Overview
      def dashboard_overview
        render json: {
          total_users: User.count,
          total_gigs: Gig.count,
          total_conversations: Conversation.count,
          total_messages: Message.count,
          total_categories: Category.count,
          total_packages: Package.count,
          total_features: Feature.count,
          total_faqs: Faq.count,
          total_availabilities: Availability.count,
          recent_activity: get_recent_activity,
          system_health: get_system_health
        }
      end

      # User Analytics
      def user_analytics
        render json: {
          user_stats: {
            total_users: User.count,
            active_users: User.where('created_at >= ?', 30.days.ago).count,
            new_users_this_month: User.where('created_at >= ?', 1.month.ago).count,
            new_users_this_week: User.where('created_at >= ?', 1.week.ago).count,
            new_users_today: User.where('created_at >= ?', 1.day.ago).count
          },
          user_roles: {
            regular_users: User.where(role: 'user').count,
            admins: User.where(role: 'admin').count,
            super_admins: User.where(role: 'superadmin').count
          },
          user_activity: {
            users_with_gigs: User.joins(:gigs).distinct.count,
            users_with_conversations: User.joins('INNER JOIN conversations ON users.id = conversations.user1_id OR users.id = conversations.user2_id').distinct.count,
            users_with_availabilities: User.joins(:availabilities).distinct.count
          },
          top_users: get_top_users,
          user_growth: get_user_growth_data
        }
      end

      # Gig Analytics
      def gig_analytics
        render json: {
          gig_stats: {
            total_gigs: Gig.count,
            active_gigs: Gig.count, # Assuming all gigs are active for now
            gigs_this_month: Gig.where('created_at >= ?', 1.month.ago).count,
            gigs_this_week: Gig.where('created_at >= ?', 1.week.ago).count,
            gigs_today: Gig.where('created_at >= ?', 1.day.ago).count
          },
          gig_categories: get_gig_categories_stats,
          gig_locations: get_gig_locations_stats,
          top_gigs: get_top_gigs,
          gig_growth: get_gig_growth_data
        }
      end

      # Communication Analytics
      def communication_analytics
        render json: {
          conversation_stats: {
            total_conversations: Conversation.count,
            conversations_this_month: Conversation.where('created_at >= ?', 1.month.ago).count,
            conversations_this_week: Conversation.where('created_at >= ?', 1.week.ago).count,
            conversations_today: Conversation.where('created_at >= ?', 1.day.ago).count
          },
          message_stats: {
            total_messages: Message.count,
            messages_this_month: Message.where('created_at >= ?', 1.month.ago).count,
            messages_this_week: Message.where('created_at >= ?', 1.week.ago).count,
            messages_today: Message.where('created_at >= ?', 1.day.ago).count,
            unread_messages: Message.where(read: false).count
          },
          communication_growth: get_communication_growth_data
        }
      end

      # System Analytics
      def system_analytics
        render json: {
          storage_stats: get_storage_stats,
          performance_stats: get_performance_stats,
          error_stats: get_error_stats,
          database_stats: get_database_stats
        }
      end

      # User Management
      def users_list
        users = User.includes(:gigs, :availabilities)
                   .order(created_at: :desc)
                   .page(params[:page] || 1)
                   .per(params[:per_page] || 20)

        render json: {
          users: users.map { |user| format_user_data(user) },
          pagination: {
            current_page: users.current_page,
            total_pages: users.total_pages,
            total_count: users.total_count
          }
        }
      end

      def user_details
        user = User.includes(:gigs, :availabilities, :messages)
                  .find(params[:id])
        
        render json: format_user_data(user, detailed: true)
      end

      def update_user_role
        user = User.find(params[:id])
        user.update!(role: params[:role])
        
        render json: { message: "User role updated successfully", user: format_user_data(user) }
      end

      def delete_user
        user = User.find(params[:id])
        user.destroy!
        
        render json: { message: "User deleted successfully" }
      end

      # Gig Management
      def gigs_list
        gigs = Gig.includes(:user, :categories, :packages, :features, :faqs)
                 .order(created_at: :desc)
                 .page(params[:page] || 1)
                 .per(params[:per_page] || 20)

        render json: {
          gigs: gigs.map { |gig| format_gig_data(gig) },
          pagination: {
            current_page: gigs.current_page,
            total_pages: gigs.total_pages,
            total_count: gigs.total_count
          }
        }
      end

      def gig_details
        gig = Gig.includes(:user, :categories, :packages, :features, :faqs)
                .find(params[:id])
        
        render json: format_gig_data(gig, detailed: true)
      end

      def delete_gig
        gig = Gig.find(params[:id])
        gig.destroy!
        
        render json: { message: "Gig deleted successfully" }
      end

      # Category Management
      def categories_list
        categories = Category.includes(:gigs)
                           .order(created_at: :desc)

        render json: {
          categories: categories.map { |category| format_category_data(category) }
        }
      end

      def create_category
        category = Category.new(category_params)
        if category.save
          render json: { message: "Category created successfully", category: format_category_data(category) }
        else
          render json: { 
            error: "Failed to create category", 
            errors: category.errors.full_messages 
          }, status: :unprocessable_entity
        end
      end

      def update_category
        category = Category.find(params[:id])
        category.update!(category_params)
        render json: { message: "Category updated successfully", category: format_category_data(category) }
      end

      def delete_category
        category = Category.find(params[:id])
        category.destroy!
        render json: { message: "Category deleted successfully" }
      end

      # System Settings
      def system_settings
        render json: {
          app_name: "WedSnap",
          version: "1.0.0",
          environment: Rails.env,
          database: Rails.configuration.database_configuration[Rails.env]['database'],
          redis_connected: begin; Redis.new.ping == "PONG"; rescue; false; end,
          storage: Rails.application.config.active_storage.service
        }
      end

      private

      def ensure_super_admin!
        unless @current_user&.role == 'superadmin'
          render json: { error: 'Access denied. Super admin privileges required.' }, status: :forbidden
        end
      end

      def category_params
        params.require(:category).permit(:name)
      end

      def format_user_data(user, detailed: false)
        data = {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          phone: user.phone,
          location: user.location,
          bio: user.bio,
          created_at: user.created_at,
          updated_at: user.updated_at,
          gigs_count: user.gigs.count,
          conversations_count: user.conversations.count,
          availabilities_count: user.availabilities.count
        }

        if detailed
          data.merge!({
            gigs: user.gigs.map { |gig| { id: gig.id, title: gig.title, created_at: gig.created_at } },
            conversations: user.conversations.map { |conv| { id: conv.id, created_at: conv.created_at } },
            availabilities: user.availabilities.map { |avail| { id: avail.id, date: avail.date, available: avail.available } }
          })
        end

        data
      end

      def format_gig_data(gig, detailed: false)
        data = {
          id: gig.id,
          title: gig.title,
          description: gig.description,
          location: gig.location,
          phone_number: gig.phone_number,
          created_at: gig.created_at,
          updated_at: gig.updated_at,
          user: { id: gig.user.id, name: gig.user.name, email: gig.user.email },
          packages_count: gig.packages.count,
          features_count: gig.features.count,
          faqs_count: gig.faqs.count,
          categories: gig.categories.map { |cat| { id: cat.id, name: cat.name } }
        }

        if detailed
          data.merge!({
            packages: gig.packages.map { |pkg| { id: pkg.id, name: pkg.name, price: pkg.price, delivery_days: pkg.delivery_days } },
            features: gig.features.map { |feat| { id: feat.id, name: feat.name } },
            faqs: gig.faqs.map { |faq| { id: faq.id, question: faq.question, answer: faq.answer } }
          })
        end

        data
      end

      def format_category_data(category)
        {
          id: category.id,
          name: category.name,
          created_at: category.created_at,
          updated_at: category.updated_at,
          gigs_count: category.gigs.count
        }
      end

      def get_recent_activity
        {
          recent_users: User.order(created_at: :desc).limit(5).map { |u| { id: u.id, name: u.name, created_at: u.created_at } },
          recent_gigs: Gig.order(created_at: :desc).limit(5).map { |g| { id: g.id, title: g.title, user: g.user.name, created_at: g.created_at } },
          recent_conversations: Conversation.order(created_at: :desc).limit(5).map { |c| { id: c.id, created_at: c.created_at } }
        }
      end

      def get_system_health
        {
          database_connected: ActiveRecord::Base.connection.active?,
          redis_connected: begin; Redis.new.ping == "PONG"; rescue; false; end,
          storage_available: true, # Add actual storage check if needed
          last_backup: "2024-01-01", # Add actual backup tracking
          uptime: "99.9%" # Add actual uptime tracking
        }
      end

      def get_top_users
        User.joins(:gigs)
            .group('users.id')
            .order(Arel.sql('COUNT(gigs.id) DESC'))
            .limit(10)
            .map { |user| { id: user.id, name: user.name, gigs_count: user.gigs.count } }
      end

      def get_user_growth_data
        (0..29).map do |i|
          date = i.days.ago.to_date
          {
            date: date,
            new_users: User.where('DATE(created_at) = ?', date).count
          }
        end.reverse
      end

      def get_gig_categories_stats
        Category.joins(:gigs)
                .group('categories.id')
                .order(Arel.sql('COUNT(gigs.id) DESC'))
                .map { |cat| { name: cat.name, count: cat.gigs.count } }
      end

      def get_gig_locations_stats
        Gig.group(:location)
           .order(Arel.sql('COUNT(*) DESC'))
           .limit(10)
           .count
           .map { |location, count| { location: location, count: count } }
      end

      def get_top_gigs
        Gig.includes(:user)
           .order(created_at: :desc)
           .limit(10)
           .map { |gig| { id: gig.id, title: gig.title, user: gig.user.name, created_at: gig.created_at } }
      end

      def get_gig_growth_data
        (0..29).map do |i|
          date = i.days.ago.to_date
          {
            date: date,
            new_gigs: Gig.where('DATE(created_at) = ?', date).count
          }
        end.reverse
      end

      def get_communication_growth_data
        (0..29).map do |i|
          date = i.days.ago.to_date
          {
            date: date,
            new_conversations: Conversation.where('DATE(created_at) = ?', date).count,
            new_messages: Message.where('DATE(created_at) = ?', date).count
          }
        end.reverse
      end

      def get_storage_stats
        {
          total_attachments: ActiveStorage::Attachment.count,
          total_blobs: ActiveStorage::Blob.count,
          storage_size: ActiveStorage::Blob.sum(:byte_size)
        }
      end

      def get_performance_stats
        {
          average_response_time: "150ms", # Add actual performance tracking
          requests_per_minute: "100", # Add actual request tracking
          error_rate: "0.1%" # Add actual error tracking
        }
      end

      def get_error_stats
        {
          total_errors_today: 0, # Add actual error tracking
          total_errors_this_week: 0,
          total_errors_this_month: 0,
          most_common_errors: [] # Add actual error tracking
        }
      end

      def get_database_stats
        {
          total_tables: ActiveRecord::Base.connection.tables.count,
          total_records: User.count + Gig.count + Conversation.count + Message.count,
          database_size: "50MB" # Add actual database size calculation
        }
      end
    end
  end
end 