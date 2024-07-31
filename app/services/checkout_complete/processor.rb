module CheckoutComplete
  class Processor
    def self.process(stripe_event)
      session = SessionManager.new(stripe_event).retrieve_session

      PaymentProcessor.new(session).process
    end
  end
end
