class CreateDecisions < ActiveRecord::Migration[8.1]
  # A migration describes a schema change. Run bin/rails db:migrate to apply it;
  # Rails records applied versions so the same migration is not run twice.
  def change
    create_table :decisions do |t|
      # References create indexed *_id columns; foreign keys prevent orphan rows.
      t.references :request, null: false, foreign_key: true
      t.references :reviewer, null: false, foreign_key: true
      t.string :outcome, null: false
      t.text :comment

      # Rails maintains created_at and updated_at automatically.
      t.timestamps
    end
  end
end
