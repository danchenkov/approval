# Approval: a first Rails project

This is the working **days 1–3 baseline** for [RAILS_README.md](RAILS_README.md): a small workflow and approval application you can run locally and extend during the later exercises. The source contains teaching comments explaining Rails conventions and the reasons for each piece.

You can create, list, view, edit, and delete requests, reviewers, and decisions. A request's detail page shows its decisions with the reviewer's name and comments. Submitting a valid new request records a fake notification in the development log. Invalid submissions show errors beside the form and retain the entered values.

The starter uses **Ruby 4.0.7, Rails 8.1.4, SQLite, and Minitest**. `Gemfile.lock` records the installed dependency versions. Pages are rendered on the server using ERB templates and plain CSS; no Node.js, JavaScript build process, email account, or authentication provider is needed.

## Run locally

Install Ruby **4.0.7** and Bundler first. `.ruby-version` tells compatible version managers which Ruby to use. If using mise, run `mise install` in this directory. See the [official Rails installation guide](https://guides.rubyonrails.org/install_ruby_on_rails.html) for platform-specific instructions. You may need a compiler and SQLite development headers if your platform cannot use the precompiled gems.

From this repository's directory:

```sh
ruby --version
bundle install
bin/rails db:prepare
bin/rails server
```

Open **http://localhost:3000**. Stop the server with **Ctrl+C**. `bin/dev` also starts this app's Rails server. After dependencies are installed, `bin/setup` prepares the database and starts the server; `bin/setup --skip-server` only prepares the app.

`db:prepare` creates missing databases, applies migrations, and loads seeds when initializing a database. To load the demo into an existing database, run:

```sh
bin/rails db:seed
```

The seeds reuse their demo records when run again. They provide one reviewer, one equipment request, and an approval. SQLite stores local data in `storage/development.sqlite3`; tests use a separate `storage/test.sqlite3`. Database files, logs, and the local credentials key are ignored by Git. This starter does not need credentials to boot after a fresh clone.

## Try the first workflow

1. Open **Reviewers**, select **New reviewer**, and enter a name and an email address.
2. Open **Requests**, select **New request**, and enter a title, description, and requester email.
3. On the request detail page, select **Record a decision**. The request is already selected. Choose a reviewer, choose **Approved** or **Rejected**, optionally add a comment, and save.
4. Return to the request detail page to see the decision. Try editing the request and decision through their detail pages.
5. Submit an empty title or an invalid email to see validation errors. A reviewer with decisions cannot be deleted; an unused reviewer can. Deleting a request also deletes its decisions.

To see the fake notification after creating a request through the UI:

```sh
tail -f log/development.log
```

Look for `[Fake notification] Request #... created`. No email is sent. Updates, decisions, and seed loading do not trigger this notification. Deliveries are also collected in an array on each `FakeNotifier` instance for tests; that array is temporary, not a persistent inbox.

## Read the code in this order

| File or directory | What to learn |
| --- | --- |
| `Gemfile` and `.ruby-version` | The Ruby version and libraries this app uses. |
| `config/routes.rb` | How URLs and HTTP verbs select controller actions. |
| `app/controllers/requests_controller.rb` | How a form submission becomes an operation and a response. |
| `app/services/submit_request.rb` | A plain Ruby object that saves a request and calls a collaborator. |
| `app/services/fake_notifier.rb` | A fake side effect you can inspect without a provider. |
| `app/models/request.rb`, `reviewer.rb`, `decision.rb` | Persistence, relationships, normalization, and validation. |
| `db/migrate/` and `db/schema.rb` | How the database structure is created and its current shape. |
| `app/views/requests/` | List/detail pages and a shared form written in HTML plus Ruby. |
| `app/views/layouts/application.html.erb` | Navigation and flash messages shared by every page. |
| `test/models/`, `test/controllers/`, `test/services/`, `test/integration/` | Model rules, HTTP behavior, service behavior, and a complete user journey. |

Rails automatically loads application classes by their file names: `app/services/submit_request.rb` defines `SubmitRequest`. You do not need to manually `require` it in the controller. A model named `Request` maps to the `requests` database table. `ApplicationRecord` is the common parent giving our models Active Record's database behavior.

The app's `Request` model is an approval request. Rails also uses the term *request* for an incoming HTTP message; those are different objects. The controller's `@request` is our model, while the controller's `request` method returns HTTP information. Integration tests use `@approval_request` because Rails' test framework reserves `@request` internally.

### Follow one form submission

1. `GET /requests/new` runs `RequestsController#new`. It builds an unsaved `Request`, then Rails renders `new.html.erb` and the `_form.html.erb` partial.
2. `form_with` creates a form targeting `POST /requests`. It includes Rails' CSRF token. The edit screen reuses the same partial and targets `PATCH /requests/:id`.
3. `create` reads the allowlisted attributes using `params.expect`, Rails' strong-parameters API. Extra submitted fields are excluded.
4. `SubmitRequest#call` builds the model and calls `save`. Active Record validates it, then inserts a row into SQLite if valid. Only a successful save triggers `FakeNotifier`.
5. Success redirects with HTTP **303** to the detail page. Failure renders the form with HTTP **422**, using the same object's values and errors. An unknown record ID returns **404**.
6. `show.html.erb` renders the request and its decisions inside the shared layout. `<%= ... %>` outputs an escaped Ruby value; `<% ... %>` runs Ruby without output; `<%# ... %>` is a comment that never reaches the browser.

### The data model and initial trade-offs

- A **Request** has a title, description, requester email, and many decisions. All three fields are required; the email must have a valid shape.
- A **Reviewer** has a required name and unique email. Emails are stripped of surrounding whitespace and lowercased before validation. A database unique index also guards against duplicate concurrent inserts.
- A **Decision** belongs to an existing request and reviewer, has an `approved` or `rejected` outcome, and an optional comment. Foreign keys prevent orphaned database rows.

Models handle persistence and record-level rules. The ordinary Ruby submission service coordinates a use case; controllers handle HTTP; views handle presentation. This is deliberately a small baseline with no class hierarchy built around future pattern assignments.

Decisions are editable CRUD records. Multiple decisions from the same reviewer are allowed, and there is no aggregate request status or automatic reviewer assignment yet. The request detail list is **not an immutable audit trail**. Policies, lifecycle transitions, durable notifications, and audit history belong to later assignments in the training brief. Removing a request removes its decisions; removing a reviewer referenced by decisions is blocked to preserve those links. Everyone using this local exercise can operate every screen; authentication and authorization are not implemented.

## Verify and explore

```sh
# Run all tests; Minitest is the consistent test framework for this project.
bin/rails test

# Run a single group while studying it.
bin/rails test test/services/submit_request_test.rb

# Check Ruby formatting and Rails' class-loading conventions.
bin/rubocop
bin/rails zeitwerk:check

# Inspect routes or open an interactive Ruby session with the app loaded.
bin/rails routes
bin/rails console
```

In the console, try `Request.first`, `Request.first.decisions`, or `Reviewer.order(:name)`. `Request.new` creates an object in memory; `save` persists it. `save` returns false for invalid data; `save!` raises an exception. Exit the console with `exit`.

Tests include successful operations and invalid/edge cases: malformed email, duplicate reviewers, invalid outcomes, missing associations, deletion rules, an unknown request, retained form values, fake notifications, and a complete reviewer → request → decision journey. Fixtures in `test/fixtures/` are named sample rows loaded for tests. Each test runs in an isolated transaction that is rolled back afterward; demo seeds are separate from fixtures.

The generated GitHub Actions workflow runs tests, formatting, and security checks. `bin/ci` runs the local checks together (including the dependency vulnerability audit, which needs network access). Prefer `db:migrate` for future schema changes, and create a new migration instead of editing an already shared/applied migration. `db/schema.rb` is generated; do not edit it by hand.

If Rails cannot load a dependency, check `ruby --version`, then rerun `bundle install`. If a page reports pending migrations, run `bin/rails db:migrate`. If port 3000 is occupied, use `bin/rails server -p 3001`. Reading `log/development.log` usually shows the action, SQL, and error responsible for a failed request.

## Written resources

Read these alongside the files above; all are text resources, with no videos required. The official Rails Guides include a version selector: use the **8.1** guides when following this starter.

### Start here

- [Ruby in Twenty Minutes](https://www.ruby-lang.org/en/documentation/quickstart/) — Ruby variables, methods, classes, and blocks before tackling Rails conventions.
- [Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html) — application structure and a first CRUD app. Focus on models, routes, controllers, views, and tests for days 1–3; its later authentication and deployment chapters exceed this starter's scope.
- [Active Record Basics](https://guides.rubyonrails.org/active_record_basics.html) — objects, tables, naming conventions, and reading/writing records.
- [Rails Routing from the Outside In](https://guides.rubyonrails.org/routing.html) — `resources`, HTTP verbs, and named route helpers.
- [Action Controller Overview](https://guides.rubyonrails.org/action_controller_overview.html) — actions, parameters, rendering, redirects, and flash messages.
- [Action View Form Helpers](https://guides.rubyonrails.org/form_helpers.html) — `form_with`, labels, fields, and association dropdowns.

### Understand this starter more deeply

- [Active Record Migrations](https://guides.rubyonrails.org/active_record_migrations.html) — schema changes, indexes, and database constraints.
- [Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html) — presence, formats, inclusion, uniqueness, and error messages.
- [Active Record Associations](https://guides.rubyonrails.org/association_basics.html) — `belongs_to`, `has_many`, and dependent deletion behavior.
- [Testing Rails Applications](https://guides.rubyonrails.org/testing.html) — Minitest assertions, fixtures, model tests, and integration tests.
- [Autoloading and Reloading Constants](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html) — why a class's file name matters and how Rails finds service objects.
- [SQLite in Five Minutes or Less](https://www.sqlite.org/quickstart.html) — the database behind the model layer and an introduction to its command-line interface.

### Keep for the later pattern exercises

The training brief already specifies these written references. Return to them when a later assignment introduces a concrete design problem:

- Gamma, Helm, Johnson, and Vlissides, *Design Patterns: Elements of Reusable Object-Oriented Software* — the original GoF pattern catalog (book; borrow or purchase).
- [Refactoring.Guru's design-pattern catalog](https://refactoring.guru/design-patterns) — intent, applicability, and trade-offs for each classical pattern.
- [Pattern Garden](https://designpatterns.guru/) — the comparison reference named in the training brief.
- [Martin Fowler's enterprise application pattern catalog](https://martinfowler.com/eaaCatalog/) — vocabulary for the supplemental architecture topics.

Before the next assignment, describe the baseline's actual pain point, sketch a simpler alternative, and write tests for the intended change. Keep that reasoning with your exercise notes rather than adding patterns ahead of the curriculum.
