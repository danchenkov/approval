# A service is an ordinary Ruby object describing an application operation.
# It does not inherit from Rails: persistence stays in Request, HTTP stays in
# RequestsController, and this object coordinates saving and a fake notification.
class SubmitRequest
  def initialize(notifier: FakeNotifier.new)
    # Passing a collaborator lets tests inspect notifications without sending mail.
    @notifier = notifier
  end

  def call(attributes)
    request = Request.new(attributes)
    # `save` returns false on validation failure. Notify only after a successful
    # save; return the object either way so the controller can render its errors.
    # Delivery is synchronous and fake. Durable delivery/retries belong to later exercises.
    @notifier.request_created(request) if request.save
    request
  end
end
