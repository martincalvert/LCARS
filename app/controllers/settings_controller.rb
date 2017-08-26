class SettingsController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def load
    settings = Setting.first
    respond_to do |format|
      format.json do
        if settings.present?
          render json: { settings: settings }
        else
          render json: { settings: Setting.create }
        end
      end
    end
  end

  def save
    settings = if id = settings_params['_id']
                 Setting.find(id)
               else
                 Setting.new
               end
    settings.update_attributes(settings_params)
    if settings.save!
      render json: { saved: true, settings: settings.to_json }
    else
      render json: { saved: false, error: settings.errors }
    end
  end

  private

  def settings_params
    params.require(:settings).permit(Setting.permitted_fields, environments: [], _id: {}).to_h
  end
end
