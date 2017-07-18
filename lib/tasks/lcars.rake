namespace :lcars do
  task :cron, [] => [:environment] do |_, _|
    require 'rufus-scheduler'

    scheduler = Rufus::Scheduler.new

    setting = Setting.first

    scheduler.every "#{setting.check_duration}s" do
      AppService.where(enabled: true).each(&:fetch_status)
    end

    scheduler.join
  end
end
