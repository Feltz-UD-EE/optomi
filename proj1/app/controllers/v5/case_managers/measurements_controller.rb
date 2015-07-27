class V5::CaseManagers::MeasurementsController < ApplicationController

  def index
    case_manager = CaseManager.find(params["case_manager_id"])
    measurements = Measurement.joins(conditions: [patients: :case_managers])
                              .where(case_managers: { id: case_manager.id },
                                     conditions: { is_track: true, deleted_at: nil },
                                     condition_measurements: { deleted_at: nil },
                                     measurements: { deleted_at: nil })

    render json: measurements

  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :case_manager_invalid, e
  end
end
