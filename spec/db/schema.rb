Schematix::Schema.define do
  table :users do
    column :email,      :string, length: 100, null: false, unique: true
    column :name,       :string,              null: false
    column :created_at, :timestamp,           null: false
    column :updated_at, :timestamp,           null: false
  end

  table :articles do
    column :title,        :string,    null: false
    column :body,         :text,      null: false
    column :created_at,   :timestamp, null: false
    column :updated_at,   :timestamp, null: false
    column :published_at, :timestamp, null: false, default: :now
    column :author_id,    :integer,   null: false, reference: [:users, :id]
  end

  view :articles_by_user, <<SQL
SELECT a.title, a.body, u.name FROM articles a INNER JOIN users u ON a.author_id = u.id
SQL
end
