class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :proposal_id
      t.integer :voter
      t.integer :relevance
      t.integer :interestingness
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
