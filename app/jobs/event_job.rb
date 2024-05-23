class EventJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "EXECUTING EVENTJOB with #{args}"
    # Do something later
  end
end
