class StripeAccount
  include Rails.application.routes.url_helpers
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def create_account
    return if account.stripe_id.present?

    stripe_account = Stripe::Account.create(
      country: 'US',
      email: account.user.email,
      business_type: 'individual',
      individual: {
        first_name: account.user.firstname,
        last_name: account.user.lastname,
        email: account.user.email,
        phone: '5005550006',
        dob: {
          day: 01,
          month: 01,
          year: 1901
        }
      },
      business_profile: {
        product_description: 'Digital creations and content',
        mcc: "5818",
        support_email: account.user.email,
        url: 'https://www.difarapizzany.com/',
      },
      company: {
        address: {
          city: 'Brooklyn',
          country: 'US',
          line1: 'address_full_match',
          line2: '1424 Avenue J',
          postal_code: '11230',
          state: 'NY'
        }
      }
    )

    account.update(stripe_id: stripe_account.id)
  end

  def onboarding_url
    Stripe::AccountLink.create({
      account: account.stripe_id,
      refresh_url: account_url,
      return_url: account_url,
      type: 'account_onboarding',
      collect: 'eventually_due',
    }).url
  end
end
