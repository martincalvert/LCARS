namespace :lcars do
  task :cron, [] => [:environment] do |_, _|
    require 'rufus-scheduler'

    scheduler = Rufus::Scheduler.new

    setting = Setting.first

    scheduler.every "#{setting.check_duration}s" do
      threads = []
      AppService.where(enabled: true).each do |app|
        threads << Thread.new do
          app.fetch_status
        end
      end
      threads.map(&:join)
    end

    scheduler.join
  end
end
