# A local stand-in for a notification provider. Nothing leaves this process.
# The array is per instance (not global); the development log lets a learner see
# the notification after submitting the form. A new instance starts with no deliveries.
class FakeNotifier
  attr_reader :deliveries

  def initialize(logger: Rails.logger)
    @logger = logger
    @deliveries = []
  end

  def request_created(request)
    message = "[Fake notification] Request ##{request.id} created"
    @deliveries << message
    @logger.info(message)
  end
end
