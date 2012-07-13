require ::File.expand_path('../spec_helper', __FILE__)

describe Recommendify::SparseMatrix do

  before(:all) do
    @sm = Recommendify::SparseMatrix.new(:redis_prefix => "recommendify-test", :key => "mysparsematrix")
  end

  before(:each) do
    flush_redis!
  end
  
  it "should build the correct keys" do
    @sm.redis_key.should == "recommendify-test:mysparsematrix"
  end

  it "should retrieve a value" do
    Recommendify.redis.hset("recommendify-test:mysparsematrix", "bar:foo", 43)
    @sm["bar", "foo"].to_i.should == 43
  end

  it "should retrieve a value regardless of parameter order" do
    Recommendify.redis.hset("recommendify-test:mysparsematrix", "one:two", 14)
    @sm["one", "two"].to_i.should == 14
    @sm["two", "one"].to_i.should == 14
  end

  it "should store a value" do
    @sm["bar", "foo"] = 123
    Recommendify.redis.hget("recommendify-test:mysparsematrix", "bar:foo").to_i.should == 123
  end

  it "should store a value regardless of parameter order" do
    @sm["foo", "bar"] = 126
    Recommendify.redis.hget("recommendify-test:mysparsematrix", "bar:foo").to_i.should == 126
  end

  it "should return 0 if the key is not found" do
    @sm["not", "set"].should == 0
  end

  it "should increment a value" do
    @sm["foo", "bar"] = 1000
    @sm.incr("foo", "bar")
    Recommendify.redis.hget("recommendify-test:mysparsematrix", "bar:foo").to_i.should == 1001
  end

  it "should increment a value regardless of parameter order" do
    @sm["foo", "bar"] = 2000
    @sm.incr("bar", "foo")
    Recommendify.redis.hget("recommendify-test:mysparsematrix", "bar:foo").to_i.should == 2001
  end

  it "should not create unneseccary keys" do
    @sm["foo", "bar"] = 90
    @sm["5asd6", "bar"] = 260
    @sm["foo", "bar"] = 45
    @sm["foo", "jefs"] = 26
    Recommendify.redis.hkeys("recommendify-test:mysparsematrix").length.should == 3
  end

  it "should create a key if the value is not 0" do
    @sm["foo", "jefs"] = 26
    Recommendify.redis.hkeys("recommendify-test:mysparsematrix").length.should == 1
  end

  it "should not create a key if the value is 0" do
    @sm["foo", "jefs"] = 0
    Recommendify.redis.hkeys("recommendify-test:mysparsematrix").length.should == 0
  end

  it "should delete a key if the value is set to 0" do
    Recommendify.redis.hset("recommendify-test:mysparsematrix", "bar:foo", 43)
    @sm["bar", "foo"] = 0
    Recommendify.redis.hkeys("recommendify-test:mysparsematrix").length.should == 0
  end

end
