require 'rails/generators/migration'

module SimpleLogin
  module Generators
    class SimpleLoginGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_migration
        migration_template 'create_users.rb', "db/migrate/create_users.rb"
        rake("db:migrate")
      end

      def generate_user
        directory "controllers", "app/controllers/"
        directory "mailers", "app/mailers/"
        directory "models", "app/models/"
        directory "views", "app/views/"
      end

      def insert_general_methods
        inject_into_file "app/controllers/application_controller.rb", after: "protect_from_forgery"  do
          a = "\n\n  private\n\n  def current_user\n"
          b = "    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]\n"
          c = "  end\n"
          d = "\n  helper_method :current_user\n\n"
          e = "  def authorize\n"
          f = "    redirect_to login_url, alert: 'Not authorized. Please login.' if current_user.nil?\n"
          g = "  end\n"
          a+b+c+d+e+f+g
        end
      end

      def insert_routes
        route("match 'signup', to: 'users#new', as: 'signup'")
        route("match 'login', to: 'sessions#new', as: 'login'")
        route("match 'logout', to: 'sessions#destroy', as: 'logout'")
        route("resources :users")
        route("resources :sessions")
        route("resources :password_resets")
      end

      def add_gems
        gem("bcrypt-ruby")
      end

      # FIXME: Should be proxied to ActiveRecord::Generators::Base
      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end
