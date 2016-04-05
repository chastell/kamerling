# frozen_string_literal: true

require 'sequel'
require_relative 'client'
require_relative 'client_repo'
require_relative 'project'
require_relative 'project_repo'
require_relative 'registration'
require_relative 'registration_repo'
require_relative 'repo'
require_relative 'result_repo'
require_relative 'task'
require_relative 'task_repo'

Sequel.extension :migration

module Kamerling
  class Repos
    class << self
      attr_writer :repos

      def <<(object)
        repos[object.class] << object
        self
      end

      def [](klass)
        repos[klass]
      end

      def client_repo
        @client_repo ||= ClientRepo.new
      end

      def db=(db)
        Sequel::Migrator.run db, "#{__dir__}/migrations"
        @repos = nil
        @db    = db
      end

      def project_repo
        @project_repo ||= ProjectRepo.new
      end

      def registration_repo
        @registration_repo ||= RegistrationRepo.new
      end

      def result_repo
        @result_repo ||= ResultRepo.new
      end

      def task_repo
        @task_repo ||= TaskRepo.new
      end

      private

      def db
        @db ||= self.db = Sequel.sqlite
      end

      def repos
        @repos ||= Hash.new do |repos, klass|
          table = "#{klass.name.split('::').last.downcase}s".to_sym
          repos[klass] = Repo.new(klass, db[table])
        end
      end
    end
  end
end
