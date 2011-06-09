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

  describe "password encryption" do
  
    before(:each) do
      @user = User.create!(@attr)
    end #before
  
    it "should have encrypted password" do
      @user.should respond_to(:encrypted_password)
    end #"should have encrypted password"
 
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end #"should set the encrypted password"
    
    describe "has_password? method" do
      
      it "should be true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end #"should be true if passwords match"
      
      it "should be false if passwords dont match" do
        @user.has_password?("invalid").should be_false
      end #"should be false if passwords dont match"
    
    end #"has_password? method"
  
    describe "authenticate method" do
    
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end # "should return nil on email/password mismatch"
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end # "should return nil for an email address with no user"
      
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end #"should return the user on email/password match"
    
    end #"authenticate method"
  
  end #"password encryption"

end #User do
