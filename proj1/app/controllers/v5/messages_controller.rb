class V5::MessagesController < ApplicationController
  # require_organization_stack

  def email
    params.require(:recipient_list)
    params.require(:subject)
    params.require(:body)
    content_type = (params[:content_type] == "text/\html" ? "text/\html" : "text/\plain")

    recipients = []
    params[:recipient_list].split(',').each do |addr|
      raise InvalidEmailRecipientList unless email_validator(addr.strip)
      recipients << addr.strip
    end

    raise InvalidEmailSender unless (params[:sender] == 'TeamAbriiz@abriiz.com' || params[:sender] == 'healthywaves@ideomed.com')

    email = MessageMailer.send_message(params[:sender], 
                                       recipients,
                                       params[:subject],
                                       params[:body],
                                       content_type).deliver

    MessageLog.create(mechanism: "email",
                      sender_ref: "API ",
                      recipient: params[:recipient_list],
                      content: "Subject: " + params[:subject] + " Body: " + params[:body])
    render json: { sent_at: Time.now.to_s }

  rescue InvalidEmailRecipientList => e
    handle_standard_error :message_email_invalid_recipient_list
  rescue InvalidEmailSender => e
    handle_standard_error :message_email_invalid_sender
  rescue ActionController::ParameterMissing => e
    error = "message_email_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  end

  def sms
    params.require(:recipient)
    params.require(:body)
    
    raise InvalidSMSRecipient unless phone_validator(params[:recipient].strip)
    raise SMSTooLong unless sms_length_validator(params[:body])

    begin
      @twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH']
      sms_message = @twilio_client.account.sms.messages.create(
        :from => "+1#{ENV['TWILIO_NUMBER']}",
        :to => "+1#{params[:recipient]}",
        :body => params[:body]
      )
      MessageLog.create(mechanism: "sms", 
                        sender_ref: "API",
                        recipient: params[:recipient], 
                        content: params[:body])
      render json: { sent_at: Time.now.to_s }
    rescue Twilio::REST::RequestError => e
      handle_standard_error :twilio_error, e
    end
  rescue InvalidSMSRecipient => e
    handle_standard_error :message_sms_invalid_recipient
  rescue SMSTooLong => e
    handle_standard_error :message_sms_too_long
  rescue ActionController::ParameterMissing => e
    error = "message_sms_missing_#{e.param.to_s}".to_sym
    handle_standard_error error, e
  end

  private
  class InvalidEmailRecipientList < StandardError; end
  class InvalidEmailSender < StandardError; end
  class SMSTooLong < StandardError; end
  class InvalidSMSRecipient < StandardError; end
  class InvalidSMSSender < StandardError; end

  def email_validator(address)
    /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\z/.match(address)
  end
  
  def phone_validator(phone)
    /\A\d{3}-?\d{3}-?\d{4}\z/.match(phone)
  end
  
  def sms_length_validator(message)
    message.length <  120    # from Twilio documentation
  end
end