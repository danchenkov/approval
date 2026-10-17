class CreateReviewers < ActiveRecord::Migration[8.1]
  # A migration describes a schema change. Run bin/rails db:migrate to apply it;
  # Rails records applied versions so the same migration is not run twice.
  def change
    create_table :reviewers do |t|
      t.string :name, null: false
      t.string :email, null: false

      # Rails maintains created_at and updated_at automatically.
      t.timestamps
    end
    # A unique index prevents duplicate email addresses even in concurrent inserts.
    add_index :reviewers, :email, unique: true
  end
end
