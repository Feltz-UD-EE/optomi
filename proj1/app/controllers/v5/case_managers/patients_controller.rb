class V5::CaseManagers::PatientsController < ApplicationController

  def index

    this_case_manager = CaseManager.find(params[:case_manager_id])
      patients = this_case_manager.user.patients.order(:id)
      patients_struct = patients.map do |patient|
        { id: patient.id,
          first_name: patient.first_name,
          last_name: patient.last_name,
          owners_email: patient.owner.email,
          last_sync: patient.last_sync.try(:strftime, "%Y-%m-%dT%T.%LZ")
        }
      end
      render json: {patients_size: patients.length,
                    patients: patients_struct }

  rescue ActiveRecord::RecordNotFound => e
    handle_standard_error :case_manager_invalid_id, e
  end

end