class V5::AlertsController < ApplicationController
  def show
    alert = Alert.find(params[:id])
    render json: alert
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :alert_not_found, e
  end

  def create
    alert = Alert.create!(alert_params)
    render json: alert
  rescue ActiveRecord::RecordInvalid => e
    handle_invalid_record_error e.record, e
  rescue ActiveRecord::InvalidForeignKey => e
    if e.message =~ /patient_custom_measurement_id_fk/
      handle_standard_error :alert_foreign_key_patient_custom_measurement, e
    elsif e.message =~ /measurement_id_fk/
      handle_standard_error :alert_foreign_key_measurement, e
    elsif e.message =~ /user_id_fk/
      handle_standard_error :alert_foreign_key_user, e
    elsif e.message =~ /patient_id_fk/
      handle_standard_error :alert_foreign_key_patient, e
    else
      handle_standard_error :alert_foreign_key_other, e
    end
  rescue => e
    handle_standard_error :alert_not_found, e
  end

  def destroy
    alert = Alert.find(params[:id])
    alert.destroy!
    render json: alert
  rescue Errors::RecordAlreadyDestroyed => e
    handle_standard_error :alert_destroy_already_destroyed, e
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :alert_not_found, e
  end

  def update
    updated_alert = Alert.find(params[:id]).update!(update_alert_params)
    render json: updated_alert
  rescue Errors::RecordAlreadyDestroyed => e
    handle_standard_error :alert_update_alert_destroyed, e
  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :alert_not_found, e
  rescue ActiveRecord::InvalidForeignKey => e
    if e.message =~ /patient_custom_measurement_id_fk/
      handle_standard_error :alert_foreign_key_patient_custom_measurement, e
    elsif e.message =~ /measurement_id_fk/
      handle_standard_error :alert_foreign_key_measurement, e
    elsif e.message =~ /user_id_fk/
      handle_standard_error :alert_foreign_key_user, e
    elsif e.message =~ /patient_id_fk/
      handle_standard_error :alert_foreign_key_patient, e
    else
      handle_standard_error :alert_foreign_key_other, e
    end
  rescue => e
    handle_standard_error :alert_not_found, e
  end

  private
  def alert_params
    params.require(:user_id)
    params.require(:alert_category_id)
    params.permit(:user_id, :patient_id, :all_patients, :alert_category_id,
                  :message, :message_type, :measurement_id, :patient_custom_measurement_id,
                  :polarity, :lower_threshold, :upper_threshold, :fractional_measurement_type)
  end

  def update_alert_params
    params.permit(:message, :message_type, :polarity, :lower_threshold, :upper_threshold)
  end
end
