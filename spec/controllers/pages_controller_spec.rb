require 'spec_helper'

describe PagesController do
  render_views

  describe "Get 'home'" do
    it "should be succesful" do 
      get 'home'
      response.should be_success
    end
    
    it "should have the right title"
      get 'home'
      response.should have_selector("title",
      :content => "Rails Tutorial | Home"
      )
    end
    
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title"
      get 'about'
      response.should have_selector("title",
      :content => "Rails Tutorial | About"
      )
    end

  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title"
      get 'contact'
      response.should have_selector("title",
      :content => "Rails Tutorial | Contact"
      )
    end

  end

end
