class V5::OrganizationsController < ApplicationController
  # require_organization_stack

  def show   #show organization information

    current_organization = Organization.find(params[:id])
    raise InvalidOrganizationId unless   current_organization

    codes_array = current_organization.codes.map do |code|
      { id: code.id,
        name: code.name,
        code: code.code }
    end

    render json: { name: current_organization.name,
                   group_codes: codes_array }
  end

  def patients  #show list of patients for organization
    patients = Patient.find_by_sql(["SELECT DISTINCT p.id, p.first_name, p.last_name, u.email as owners_email, p.last_sync
                                    FROM organizations o
                                    JOIN codes c
                                      ON o.id = c.organization_id
                                    JOIN subscriptions s
                                      ON c.id = s.code_id
                                    JOIN patient_privileges pp
                                      ON s.user_id = pp.user_id
                                    JOIN patients p
                                      ON pp.patient_id = p.id
                                    JOIN users u
                                      ON pp.user_id = u.id
                                    WHERE active = true
                                    AND pp.type = 'PatientPrivilege::Owner'
                                    AND o.id = ? Order By p.id", params[:id]])

    render json: { :patients_size => patients.length, :patients => patients }
  end

  private
  class InvalidOrganizationId < StandardError; end
end