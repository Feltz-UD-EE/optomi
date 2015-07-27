# Copyright 2013 Ideomed, Inc. All rights reserved

class ApiErrorLog < ActiveRecord::Base
  STANDARD_ERRORS = { invalid_address: { code: 404, text: "Invalid address" },
                      general_failure: { code: 500, text: "Internal Exception" },

                      # Multiple Controllers
                      # access_token authentication
                      missing_access_token: { code: 401, text: 'Unauthorized Request' },
                      invalid_access_token: { code: 401, text: 'Unauthorized Request' },
                      revoked_access_token: { code: 401, text: 'Unauthorized Request' },
                      expired_access_token: { code: 401, text: 'Access token has expired, please refresh.'},
                      # Multiple Controllers
                      # authorizing
                      auth_no_current_organization_stack: { code: 403, text: 'Unauthorized Request' },

                      # tokens_controller
                      # authentication
                      auth_missing_auth_type: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_client_uid: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_client_secret: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_user_uid: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_user_email: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_patient_mobile_pin: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_username: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_password: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_client_uid: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_client_secret: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_client_type: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_user_uid: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_user_for_client: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_user_email: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_patient_mobile_pin: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_user_for_patient: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_auth_type: { code: 401, text: 'Unauthorized Request' },
                      # refreshing & revoking
                      auth_access_token_not_expired: { code: 400, text: 'Access token is not expired.' },
                      auth_access_token_already_revoked: { code: 400, text: 'Access token is already revoked.' },
                      auth_missing_token: { code: 401, text: 'Unauthorized Request' },
                      auth_missing_refresh_token: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_access_token: { code: 401, text: 'Unauthorized Request' },
                      auth_invalid_refresh_token: { code: 401, text: 'Unauthorized Request' },


                      # Controller: patients
                      patient_invalid_id: { code: 400, text: "Please provide a valid patient ID."},
                      patient_missing_dates: { code: 400, text: "Please provide a begin date and end date." },
                      patient_malformed_dates: { code: 400, text: "Incorrectly formatted begin date or end date." },

                      # patients/....
                      patients_invalid_measurement_id: { code: 400, text: "Please provide a valid measurement_id." },
                      patients_invalid_patient_custom_measurement_id: { code: 400, text: "Please provide a valid patient_custom_measurement_id." },

                      invitation_invalid_access_level: { code: 400, text: 'Please provide a valid access_level' },
                      invitation_invalid_user_ids: { code: 400, text: 'Please provide valid user_ids' },
                      invitation_invalid_code_id: { code: 400, text: 'Please provide a valid code_id' },
                      invitation_invalid_patient_dob: { code: 400, text: 'Please provide a valid patient_dob' },
                      invitation_invalid_patient_gender: { code: 400, text: 'Please provide a valid patient_gender' },
                      invitation_invalid_track_ids: { code: 400, text: 'Please provide valid track_ids' },
                      invitation_invalid_patient_is_user: { code: 400, text: 'Please provide a valid patient_is_user' },
                      invitation_invalid: { code: 400, text: 'Please provide a valid invitation id' },
                      invitation_missing_access_level: { code: 400, text: "Please provide an access_level" },
                      invitation_missing_user_ids: { code: 400, text: 'Please provide user_ids' },
                      invitation_missing_code_id: { code: 400, text: 'Please provide a code_id' },
                      invitation_missing_patient_first_name: { code: 400, text: 'Please provide a patient_first_name' },
                      invitation_missing_patient_last_name: { code: 400, text: 'Please provide a patient_last_name' },
                      invitation_missing_patient_dob: { code: 400, text: 'Please provide a patient date of birth' },
                      # invitation_missing_patient_dob: { code: 400, text: 'Please provide a patient_dob' },
                      # invitation_missing_patient_gender: { code: 400, text: 'Please provide a patient_gender' },
                      invitation_missing_track_ids: { code: 400, text: 'Please provide track_ids' },
                      invitation_missing_patient_is_user: { code: 400, text: 'Please provide a patient_is_user' },

                      invitation_token_invalid: { code: 400, text: "Invalid invitation token" },
                      invitation_token_missing: { code: 400, text: "Please provide an invitation token" },
                      # Controller: case_managers
                      # associate
                      case_manager_invalid_id: { code: 400, text: 'invalid case manager id'},
                      case_manager_invalid_user: { code: 400, text: 'Invalid user' },
                      case_manager_already_exists: { code: 400, text: 'The specified user is already a case manager.' },
                      case_manager_not_admin: { code: 403, text: 'Current case manager does not have permission to complete this request.' },

                      case_manager_create_invalid_organization_id: { code: 400, text: 'Please provide a valid organization_id.' },
                      case_manager_create_invalid_code_id: { code: 400, text: 'Please provide a valid code_id.' },
                      case_manager_create_organization_mismatch: { code: 400, text: 'Please provide a valid code_id for the organization.' },
                      case_manager_create_current_organization_mismatch: { code: 400, text: 'Please provide a valid organization_id.' },
                      case_manager_create_missing_email: { code: 400, text: 'Please provide an email.' },
                      case_manager_create_missing_first_name: { code: 400, text: 'Please provide a first_name.' },
                      case_manager_create_missing_last_name: { code: 400, text: 'Please provide a last_name.' },
                      case_manager_create_missing_address: { code: 400, text: 'Please provide an address.' },
                      case_manager_create_missing_city: { code: 400, text: 'Please provide a city.' },
                      case_manager_create_missing_state: { code: 400, text: 'Please provide a state.' },
                      case_manager_create_missing_zip_code: { code: 400, text: 'Please provide a zip_code.' },
                      case_manager_create_missing_home_phone: { code: 400, text: 'Please provide a home_phone.' },
                      case_manager_create_missing_organization_id: { code: 400, text: 'Please provide an organization_id.' },
                      case_manager_create_missing_code_id: { code: 400, text: 'Please provide a code_id.' },
            		      case_manager_invalid_id: { code: 400, text: 'Invalid case manager id'},
                      case_manager_invalid: { code: 400, text: 'Specified case_manager_id is invalid.'},
                      case_manager_mismatch: { code: 400, text: 'Current case manager does not match specified id.'},

                      case_manager_designate_invalid_organization_id: { code: 400, text: 'Please provide a valid organization_id.' },
                      case_manager_designate_organization_mismatch: { code: 400, text: 'Specified organization does not match group code for user.' },
                      case_manager_designate_missing_user_id: { code: 400, text: 'Please provide a code_id.' },
                      case_manager_designate_missing_organization_id: { code: 400, text: 'Please provide an organization_id.' },

                      unauthorized_case_manager: { code: 400, text: 'You are not authorized to see the specified case manager\'s information.' },

                      message_email_invalid_recipient_list: { code: 400, text: 'Invalid recipient list.' },
                      message_email_invalid_sender: { code: 400, text: 'Invalid sender.' },
                      message_email_missing_recipient_list: { code: 400, text: 'Please provide a recipient list.' },
                      message_email_missing_sender: { code: 400, text: 'Please provide a sender.' },
                      message_email_missing_subject: { code: 400, text: 'Please provide a subject.' },
                      message_email_missing_body: { code: 400, text: 'Please provide the email body.' },
                      message_sms_invalid_recipient: { code: 400, text: 'Invalid recipient phone number.' },
                      message_sms_too_long: { code: 400, text: 'Message too long.' },
                      message_sms_missing_recipient: { code: 400, text: 'Please provide a recipient.' },
                      message_sms_missing_body: { code: 400, text: 'Please provide the sms body.' },
                      twilio_error: {code: 400, text: "twilio client error"},

                      # Controller: codes
                      # features
                      code_invalid: { code: 400, text: 'Invalid group code.' },

                      alert_not_found: { code: 400, text: 'Please provide a valid alert id.' },
                      alert_destroy_already_destroyed: { code: 400, text: 'Alert is already deleted.' },
                      alert_update_alert_destroyed: { code: 400, text: 'Alert is deleted.' },
                      alert_params_threshold_invalid: { code: 400, text: "Missing or invalid threshold."},
                      alert_foreign_key_measurement: { code: 400, text: "Specified measurement does not exist."},
                      alert_foreign_key_patient_custom_measurement: { code: 400, text: "Specified patient custom measurement does not exist."},
                      alert_foreign_key_user: { code: 400, text: "Specified user does not exist."},
                      alert_foreign_key_patient: { code: 400, text: "Specified patient does not exist."},
                      alert_foreign_key_other: { code: 400, text: "Alert could not be created."},

                      alert_occurrence_missing_alert_id: { code: 400, text: 'Please provide an alert_id.' },
                      alert_occurrence_missing_patient_id: { code: 400, text: 'Please provide an patient_id.' },
                      alert_occurrence_invalid_alert_id: { code: 400, text: 'Please provide a valid alert_id.' },

                      alert_occurrence_invalid_deleted_alert: { code: 400, text: 'Alert has been deleted.' },
                      alert_occurrence_not_found: { code: 400, text: 'Please provide a valid alert_occurrence id.' },

                      invalid_object: { code: 400 } }

  belongs_to :user
  belongs_to :api_client

  serialize :params
  serialize :exception_backtrace
end
