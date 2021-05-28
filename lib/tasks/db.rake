namespace :db do
  desc "Drop, create, migrate and seed database"
  task :full_reset => :environment do
    require 'rake'

    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    PascalAbcHelper::Application.load_tasks

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
end
