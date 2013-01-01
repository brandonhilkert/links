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

  context "when not instantiated" do
    it "produces a 6 digit key as a string" do
      Project::List.new.to_s.size == 6
    end
  end

  it "has a key" do
    list.key.should == "list:asdf"
  end

  it "can retrieve urls for a key" do
    Project.redis.hset(list.key, "asdf3", "http://google.com")
    Project.redis.hset(list.key, "asdf", "http://apple.com")
    list.urls.should have(2).urls
  end

  it "can create a new url" do
    Project.redis.hset(list.key, "asdf", "http://google.com")
    url = list.add_url("http://apple.com")
    list.urls.should have(2).urls

    url.should == { id: url.fetch(:id), url: "http://apple.com" }
  end

  it "adds protocol if link doesn't have it" do
    url = list.add_url("apple.com")
    url.fetch(:url).should == "http://apple.com"
  end

  it "can delete an url" do
    Project.redis.hset(list.key, "asdf3", "http://google.com")
    Project.redis.hset(list.key, "asdf", "http://apple.com")
    list.remove_url("asdf")

    list.urls.should have(1).urls
    list.urls.should_not include({ "asdf" => "http://apple.com"})
  end
end
