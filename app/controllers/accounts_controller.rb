class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :create]

  def show
    render
  end

  def create
    service = StripeAccount.new(@account)
    service.create_account

    redirect_to service.onboarding_url, allow_other_host: true, status: :see_other
  end

  private

  def set_account
    @account = current_user.account || create_user_account
  end

  def create_user_account
    Account.create(user: current_user)
  end
end
