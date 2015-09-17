require 'sequel'
require_relative 'client'
require_relative 'client_repo'
require_relative 'project'
require_relative 'project_repo'
require_relative 'registration'
require_relative 'registration_repo'
require_relative 'repo'
require_relative 'task'

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

      def clients
        repos[Client].all
      end

      def clients_for(project)
        repos[Registration].related_to(project).map(&:client)
      end

      def db=(db)
        Sequel::Migrator.run db, "#{__dir__}/migrations"
        @repos = nil
        @db    = db
      end

      def free_clients_for(project)
        clients_for(project).reject(&:busy)
      end

      def next_task_for(project)
        repos[Task].related_to(project).reject(&:done).first
      end

      def project_repo
        @project_repo ||= ProjectRepo.new
      end

      def project(project_uuid)
        repos[Project][project_uuid]
      end

      def projects
        repos[Project].all
      end

      def registration_repo
        @registration_repo ||= RegistrationRepo.new
      end

      def tasks_for(project)
        repos[Task].related_to(project)
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
