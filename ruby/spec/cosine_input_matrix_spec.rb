require ::File.expand_path('../spec_helper', __FILE__)

describe Recommendify::CosineInputMatrix do

  before(:all) do
    @matrix = Recommendify::CosineInputMatrix.new(:redis_prefix => "recommendify-test", :key => "mymatrix")
  end

  before(:each) do
    flush_redis!
  end

  it_should_behave_like Recommendify::InputMatrix
  it_should_behave_like Recommendify::CCMatrix

  it "should calculate the correct cosine similarity (here be dragons)"

end