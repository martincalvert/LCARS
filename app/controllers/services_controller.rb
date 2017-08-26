class ServicesController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #
  # def index
  #   apps = Service.all.to_a
  #   respond_to do |format|
  #     format.json do
  #       render json: { apps: apps }
  #     end
  #   end
  # end

  def index
    params.permit(:environment)
    apps = Service.where(environment: params[:environment]).to_a
    up = 0
    down = 0
    apps.each { |app| app.alive ? up += 1 : down += 1 }
    respond_to do |format|
      format.json do
        render json: { statuses: { apps: apps, down: down, up: up } }
      end
    end
  end

  def new
    app = Service.new.to_json
    respond_to do |format|
      format.json do
        render json: { app: app }
      end
    end
  end

  def save
    app = if id = app_service_params['_id']
            app_service = Service.find(id)
            app_service if app_service.update_attributes!(app_service_params)
          else
            Service.create(app_service_params)
          end
    if app.present?
      render json: { saved: true, app: app.to_json }
    else
      render json: { saved: false, error: true }
    end
  end

  def destroy
    if app = Service.find(destroy_id) and app.destroy!
      render json: { deleted: true, errors: [] }
    else
      render json: { deleted: false, errors: app.errors }
    end
  end

  private

  def app_service_params
    params.require(:app).permit(Service.permitted_fields, _id: {}).to_h
  end

  def destroy_id
    request.headers['X-APP-ID']
  end
end
