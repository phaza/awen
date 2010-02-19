if defined?(ActionController::Base)
  ActionDispatch::ShowExceptions.rescue_responses.update('ActionController::Forbidden' => :forbidden)
end
