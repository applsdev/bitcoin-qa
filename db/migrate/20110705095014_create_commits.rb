class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :commit_id
      t.datetime :committed_date
      t.datetime :authored_date
      t.text :message
      t.string :tree
      t.integer :committer_id

      t.timestamps
    end
  end
end
