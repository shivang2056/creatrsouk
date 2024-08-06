class StripeAccount
  include Rails.application.routes.url_helpers
  attr_reader :account, :store

  MCC_CODE = "5818"
  BUSINESS_TYPE = 'individual'
  PHONE_NUMBER = '5454545454'
  DEFAULT_DOB = { day: 1, month: 1, year: 1901 }
  BUSINESS_DESCRIPTION = 'Digital creations and content'
  BUSINESS_URL = 'https://www.creatrsouk.xyz/'
  US_COUNTRY_CODE = 'US'
  CITY = 'Brooklyn'
  LINE1 = 'address_full_match'
  LINE2 = '1111 Test St'
  POSTAL_CODE = '11230'
  STATE = 'NY'

  def initialize(account)
    @account = account
    @store = account.user.store
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def create_account
    return if account.stripe_id.present?

    stripe_account = Stripe::Account.create(stripe_account_params)
    account.update(stripe_id: stripe_account.id)
  end

  def update_account_branding
    return if store.background_color.nil? || store.highlight_color.nil?

    Stripe::Account.update(account.stripe_id, { settings: branding_params })
  end

  def onboarding_url
    Stripe::AccountLink.create(onboarding_params).url
  end

  private

  def stripe_account_params
    {
      country: US_COUNTRY_CODE,
      email: account.user.email,
      business_type: BUSINESS_TYPE,
      individual: individual_details,
      business_profile: business_profile_details,
      company: company_details,
      settings: branding_params
    }
  end

  def individual_details
    {
      first_name: account.user.firstname,
      last_name: account.user.lastname,
      email: account.user.email,
      phone: PHONE_NUMBER,
      dob: DEFAULT_DOB
    }
  end

  def business_profile_details
    {
      product_description: BUSINESS_DESCRIPTION,
      mcc: MCC_CODE,
      support_email: account.user.email,
      url: BUSINESS_URL,
    }
  end

  def company_details
    {
      address: {
        city: CITY,
        country: US_COUNTRY_CODE,
        line1: LINE1,
        line2: LINE2,
        postal_code: POSTAL_CODE,
        state: STATE
      }
    }
  end

  def onboarding_params
    {
      account: account.stripe_id,
      refresh_url: account_url,
      return_url: account_url,
      type: 'account_onboarding',
      collect: 'eventually_due',
    }
  end

  def branding_params
    {
      branding: {
        primary_color: store.background_color,
        secondary_color: store.highlight_color
      }
    }
  end
end
