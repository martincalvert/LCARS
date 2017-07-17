class StatusesController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    apps = Status.all.to_a
    statuses = []
    Setting.first.envs.each do |env|
      temp = {}
      temp[:env] = env
      temp[:statuses] = apps.select { |app| app.env == env }
      statuses << temp
    end
    respond_to do |format|
      format.json do
        render json: { statuses: statuses }
      end
    end
  end

  def save
    render json: { sorry: 'This is not currently supported' }
  end
end
