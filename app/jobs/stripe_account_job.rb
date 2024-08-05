class StripeAccountJob < ApplicationJob
  queue_as :default

  def perform(account, action:)
    service = StripeAccount.new(account)

    case action
    when :update_branding
      service.update_account_branding
    end
  end
end
