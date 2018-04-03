module StripeWrapper
  class Charge
    attr_reader :response, :status
    def initialize(response, status)
      @response = response
      @status = status
    end
    def self.create(options={})
      begin
        customer = Stripe::Customer.create(email: options[:email], source: options[:source])
        response = Stripe::Charge.create(amount: 999, currency: 'usd', customer: customer.id, description: options[:description])
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end
    def successful?
      status == :success
    end
    def error_message
      response.message
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

end