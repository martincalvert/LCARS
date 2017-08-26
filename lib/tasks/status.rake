require 'thread/pool'

namespace :lcars do
  task :cron, [] => [:environment] do |_, _|
    scheduler = Rufus::Scheduler.new

    scheduler.every '15s' do
      pool = Thread::Pool.new(5, 5)
      Setting.first.environments.each do |env|
        Service.where(enabled: true, environment: env).each do |app|
          pool.process do
            app.fetch_status
          end
        end
        pool.wait(:done)
      end
    end

    scheduler.join
  end

  namespace :assets do
    desc 'Precompile our rails assets'
    task deploy: :environment do
      Rake::Task['assets:precompile'].invoke
    end
  end
end


# Benchmark.measure do
#   pool = Thread::Pool.new(5, 5)
#   Setting.first.environments.each do |env|
#     Service.where(enabled: true, environment: env).each do |app|
#       pool.process do
#         app.fetch_status
#       end
#     end
#     pool.wait(:done)
#   end
# end
