class CreateRequests < ActiveRecord::Migration[8.1]
  # A migration describes a schema change. Run bin/rails db:migrate to apply it;
  # Rails records applied versions so the same migration is not run twice.
  def change
    create_table :requests do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :requester_email, null: false

      # Rails maintains created_at and updated_at automatically.
      t.timestamps
    end
  end
end
