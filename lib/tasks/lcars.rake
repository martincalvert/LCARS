require 'thread/pool'

namespace :lcars do
  task :cron, [] => [:environment] do |_, _|
    require 'rufus-scheduler'

    scheduler = Rufus::Scheduler.new

    scheduler.every '10s' do
      Setting.first.envs.each do |env|
        pool = Thread::Pool.new(1, 30)
        AppService.where(enabled: true, environment: env).each do |app|
          pool.process do
            app.fetch_status
          end
        end
        pool.wait(:done)
      end
    end

    scheduler.join
  end
end
