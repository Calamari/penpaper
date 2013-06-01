require 'spec_helper'

describe SessionsController do
  context "#new" do
    it 'shows the form' do
      get :new
      response.status.should be 200
      response.should render_template("new")
    end
  end

  context "#create" do
    let!(:user) { Fabricate(:user) }

    it 'can succeed' do
      get :create, :email => user.email, :password => 'password'
      session[:user_id].should eql user.id
      response.should redirect_to("/")
    end

    it 'can fail' do
      get :create, :email => user.email, :password => 'passwort'
      flash[:alert].should_not be_nil
      response.should render_template("new")
    end
  end

  context "#destroy" do
    let!(:user) { Fabricate(:user) }

    it 'logs out the user' do
      session[:user_id] = user.id
      delete :destroy, :id => user.id
      session[:user_id].should eql nil
      response.should redirect_to("/")
      flash[:success].should eql "Successfully logged out!"
    end
  end
end
