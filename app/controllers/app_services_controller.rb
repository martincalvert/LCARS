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

  def save
    app = if id = app_service_params['_id']
            app_service = AppService.find(id)
            app_service if app_service.update_attributes!(app_service_params)
          else
            AppService.create(app_service_params)
          end
    if app.present?
      render json: { saved: true, app: app.to_json }
    else
      render json: { saved: false, error: true }
    end
  end

  def destroy
    if app = AppService.find(destroy_id) and app.destroy!
      render json: { deleted: true, errors: [] }
    else
      render json: { deleted: false, errors: app.errors }
    end
  end

  private

  def app_service_params
    params.require(:app).permit(AppService.permitted_fields, uris: [], _id: {}).to_h
  end

  def destroy_id
    request.headers['X-APP-ID']
  end
end
