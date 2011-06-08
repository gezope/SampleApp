require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar"
              }
  end

  it "should create a new valid instance" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge( :name => "" ))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names which are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject email duplication" do
    # Put the given user to the DB
    User.create!(@attr)
    user_with_duplicated_email = User.new(@attr)
    user_with_duplicated_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_eamil = @attr[:email].upcase
    User.create!(@attr.merge( :email => upcased_eamil ))
    user_with_duplicated_email = User.new(@attr)
    user_with_duplicated_email.should_not be_valid
  end
  
  describe "password validations" do
  
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should rewuire a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      too_long = "a"*41
      helpful_hash = @attr.merge(:password => too_long, :password_confirmation => too_long)
      User.new(helpful_hash).should_not be_valid
    end
  end
  
end
