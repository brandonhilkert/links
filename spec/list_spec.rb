require 'spec_helper'

describe Project::List do
  let(:list) { Project::List.new("asdf") }

  context "when instantiated" do
    it "responds to ID" do
      list.id.should == "asdf"
    end

    it "responds to to_s" do
      list.to_s.should == "asdf"
    end
  end

  it "has a key" do
    list.key.should == "list:asdf"
  end

  it "can retrieve urls for a key" do
    Project.redis.sadd(list.key, "http://google.com")
    Project.redis.sadd(list.key, "http://apple.com")
    list.urls.should have(2).urls
  end

  it "can create a new url" do
    Project.redis.sadd(list.key, "http://google.com")
    list.add_url("http://apple.com")
    list.urls.should have(2).urls
  end

  it "can delete an url" do
    Project.redis.sadd(list.key, "http://google.com")
    Project.redis.sadd(list.key, "http://apple.com")
    list.remove_url("http://apple.com")

    list.urls.should have(1).urls
    list.urls.should_not include("http://apple.com")
  end
end