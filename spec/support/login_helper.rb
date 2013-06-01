module RSpec::LoginHelper
  def login_user(user)
    controller.stub(:current_user).and_return(user)
  end

  def logout_user
    controller.stub(:current_user).and_return(nil)
  end
end
