# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  
	before do
		@user = User.new(name: "Example User", email: "example@user.com", 
						password: "foobar", password_confirmation: "foobar")
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should be_valid }

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "When name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "When name is too long" do
		before { @user.name = "a" * 51 } #Make the user name 51 characters long
		it { should_not be_valid }
	end

	describe "When name is invalid" do
		it "should be invalid" do
			names = %w[j@ames cl1nt b0b]
			names.each do | invalid_name | 
				@user.name = invalid_name
				@user.should_not be_valid
			end
		end
	end

	describe "When email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "When email format is invalid" do
	it "should be invalid" do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo. sample.user@example.example.]
		addresses.each do | invalid_address |
			@user.email = invalid_address
			@user.should_not be_valid
			end
		end
	end

	describe "When email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do | valid_address |
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "When an email addresses is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase #Make sure that this test is case insensitive
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "When password is not present" do
		before { @user.password = @user.password_confirmation = " "}
		it { should_not be_valid}
	end

	describe "When passwords do not match" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "When password confirmation is nil" do
		before { @user.password_confirmation = nil}
		it { should_not be_valid }
	end

	describe "When password is too short" do
		before { @user.password = @user.password_confirmation = "a" * 5}
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end
