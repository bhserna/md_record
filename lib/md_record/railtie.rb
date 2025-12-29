# frozen_string_literal: true

module MdRecord
  class Railtie < Rails::Railtie
    initializer "md_record.configure_rescue_responses" do
      ActionDispatch::ExceptionWrapper.rescue_responses["MdRecord::RecordNotFound"] = :not_found
    end
  end
end
