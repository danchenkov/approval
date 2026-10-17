# A controller translates an HTTP request into a model/service operation and
# an HTML response. Rails automatically renders the matching action's template
# unless we explicitly render or redirect. This starter serves HTML only.
class RequestsController < ApplicationController
  # Before these four actions, load the row identified by the URL's :id.
  before_action :set_request, only: %i[ show edit update destroy ]

  # GET /requests: collection page.
  def index
    @requests = Request.order(created_at: :desc, id: :desc)
  end

  # GET /requests/:id: detail page; @variables are available in the template.
  def show
    # Eager loading avoids a separate reviewer query for every decision in the view.
    @decisions = @request.decisions.includes(:reviewer).order(created_at: :desc, id: :desc)
  end

  # GET /requests/new: an unsaved object supplies the blank form's fields.
  def new
    @request = Request.new
  end

  # GET /requests/:id/edit: the same form, populated from the existing row.
  def edit
  end

  # POST /requests: process a submitted form.
  def create
    @request = SubmitRequest.new.call(request_params)
    if @request.persisted?
      # Redirect after a write so refreshing the page does not repeat the POST.
      redirect_to @request, notice: "Request was successfully created.", status: :see_other
    else
      # Rendering keeps the object's entered values and validation errors.
      # HTTP 422 says the form was understood but its content was invalid.
      render :new, status: :unprocessable_content
    end
  end

  # PATCH /requests/:id: update runs model validations before writing to SQLite.
  def update
    if @request.update(request_params)
      redirect_to @request, notice: "Request was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /requests/:id: button_to sends this verb using an ordinary HTML form.
  def destroy
    @request.destroy!
    redirect_to requests_path, notice: "Request was successfully deleted.", status: :see_other
  end

  private

    def set_request
      # find raises RecordNotFound for an unknown ID; Rails turns that into a 404.
      @request = Request.find(params.expect(:id))
    end

    def request_params
      # Strong parameters require the form's top-level key and allow only these
      # attributes. Never pass every browser-supplied parameter into a model.
      params.expect(request: [ :title, :description, :requester_email ])
    end
end
