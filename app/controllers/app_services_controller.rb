class AppServicesController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    apps = AppService.all.to_a
    respond_to do |format|
      format.json do
        render json: { apps: apps }
      end
    end
  end

  def new
    app = AppService.new.to_json
    respond_to do |format|
      format.json do
        render json: { app: app }
      end
    end
  end

  def create
    # TODO: Check boolean stuff and uris
    binding.pry
    if app = AppService.create(app_service_params)
      render json: { saved: true, app: app.to_json }
    else
      render json: { saved: false, error: true }
    end
  end

  def destroy
    if app = AppService.find(params[:app][:id]) and app.destroy
      render json: { deleted: true, errors: [] }
    else
      render json: { deleted: false, errors: app.errors }
    end
  end

  private

  def app_service_params
    params.require(:app).permit(AppService.permitted_fields)
  end
end
