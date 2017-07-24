class StatusesController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    params.permit(:environment)
    apps = Status.where(enabled: true, environment: params[:environment]).to_a
    respond_to do |format|
      format.json do
        render json: { statuses: apps }
      end
    end
  end

  # TODO: Allow statuses to be recieved and saved in case there is an outside source blocking a service
  def save
    render json: { sorry: 'This is not currently supported' }
  end
end
