module RequestSpecHelper
  def sign_in_user
    user = create(:user)
    sign_in user
    user
  end
end
