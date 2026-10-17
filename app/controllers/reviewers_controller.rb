# A controller translates an HTTP request into a model/service operation and
# an HTML response. Rails automatically renders the matching action's template
# unless we explicitly render or redirect. This starter serves HTML only.
class ReviewersController < ApplicationController
  # Before these four actions, load the row identified by the URL's :id.
  before_action :set_reviewer, only: %i[ show edit update destroy ]

  # GET /reviewers: collection page.
  def index
    @reviewers = Reviewer.order(:name)
  end

  # GET /reviewers/:id: detail page; @variables are available in the template.
  def show
  end

  # GET /reviewers/new: an unsaved object supplies the blank form's fields.
  def new
    @reviewer = Reviewer.new
  end

  # GET /reviewers/:id/edit: the same form, populated from the existing row.
  def edit
  end

  # POST /reviewers: process a submitted form.
  def create
    @reviewer = Reviewer.new(reviewer_params)
    if @reviewer.save
      # Redirect after a write so refreshing the page does not repeat the POST.
      redirect_to @reviewer, notice: "Reviewer was successfully created.", status: :see_other
    else
      # Rendering keeps the object's entered values and validation errors.
      # HTTP 422 says the form was understood but its content was invalid.
      render :new, status: :unprocessable_content
    end
  end

  # PATCH /reviewers/:id: update runs model validations before writing to SQLite.
  def update
    if @reviewer.update(reviewer_params)
      redirect_to @reviewer, notice: "Reviewer was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /reviewers/:id: button_to sends this verb using an ordinary HTML form.
  def destroy
    if @reviewer.destroy
      redirect_to reviewers_path, notice: "Reviewer was successfully deleted.", status: :see_other
    else
      # restrict_with_error puts a human-readable message on the model.
      redirect_to @reviewer, alert: @reviewer.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

    def set_reviewer
      # find raises RecordNotFound for an unknown ID; Rails turns that into a 404.
      @reviewer = Reviewer.find(params.expect(:id))
    end

    def reviewer_params
      # Strong parameters require the form's top-level key and allow only these
      # attributes. Never pass every browser-supplied parameter into a model.
      params.expect(reviewer: [ :name, :email ])
    end
end
