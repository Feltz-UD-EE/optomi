class ErrorsController < ApplicationController
  
  def not_found
    handle_standard_error(:invalid_address)
  end
end