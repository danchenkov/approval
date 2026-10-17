# A controller translates an HTTP request into a model/service operation and
# an HTML response. Rails automatically renders the matching action's template
# unless we explicitly render or redirect. This starter serves HTML only.
class DecisionsController < ApplicationController
  # Before these four actions, load the row identified by the URL's :id.
  before_action :set_decision, only: %i[ show edit update destroy ]

  # GET /decisions: collection page.
  def index
    @decisions = Decision.includes(:request, :reviewer).order(created_at: :desc, id: :desc)
  end

  # GET /decisions/:id: detail page; @variables are available in the template.
  def show
  end

  # GET /decisions/new: an unsaved object supplies the blank form's fields.
  def new
    @decision = Decision.new(request_id: params[:request_id])
  end

  # GET /decisions/:id/edit: the same form, populated from the existing row.
  def edit
  end

  # POST /decisions: process a submitted form.
  def create
    @decision = Decision.new(decision_params)
    if @decision.save
      # Redirect after a write so refreshing the page does not repeat the POST.
      redirect_to @decision, notice: "Decision was successfully created.", status: :see_other
    else
      # Rendering keeps the object's entered values and validation errors.
      # HTTP 422 says the form was understood but its content was invalid.
      render :new, status: :unprocessable_content
    end
  end

  # PATCH /decisions/:id: update runs model validations before writing to SQLite.
  def update
    if @decision.update(decision_params)
      redirect_to @decision, notice: "Decision was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /decisions/:id: button_to sends this verb using an ordinary HTML form.
  def destroy
    @decision.destroy!
    redirect_to decisions_path, notice: "Decision was successfully deleted.", status: :see_other
  end

  private

    def set_decision
      # find raises RecordNotFound for an unknown ID; Rails turns that into a 404.
      @decision = Decision.find(params.expect(:id))
    end

    def decision_params
      # Strong parameters require the form's top-level key and allow only these
      # attributes. Never pass every browser-supplied parameter into a model.
      params.expect(decision: [ :request_id, :reviewer_id, :outcome, :comment ])
    end
end
