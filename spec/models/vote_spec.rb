require 'spec_helper'

describe Vote do
  before(:each) do
    @valid_attributes = {
      :proposal_id => 1,
      :voter => 1,
      :relevance => 1,
      :interestingness => 1,
      :comments => "value for comments"
    }
  end

  it "should create a new instance given valid attributes" do
    Vote.create!(@valid_attributes)
  end
end
