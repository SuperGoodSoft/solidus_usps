# frozen_string_literal: true

module SolidusUsps
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false
      source_root File.expand_path('templates', __dir__)

      def self.exit_on_failure?
        true
      end

      def copy_initializer
        template 'initializer.rb', 'config/initializers/solidus_usps.rb'
      end

      def add_migrations
        run 'bin/rails railties:install:migrations FROM=solidus_usps'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]')) # rubocop:disable Layout/LineLength
        if run_migrations
          run 'bin/rails db:migrate'
        else
          puts 'Skipping bin/rails db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
        end
      end

      def include_seeds
        if ['', 'y', 'Y'].include?(ask('Would you like to have seed data populated now? [Y/n]'))
          SolidusUsps::Engine.load_seed
        else
          puts "Skipping seeds. Don't forget to create the necessary shipping categories!"
        end
      end
    end
  end
end
