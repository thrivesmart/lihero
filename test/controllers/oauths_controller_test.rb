require 'test_helper'

class OauthsControllerTest < ActionController::TestCase
  setup do
    @oauth = oauths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oauths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create oauth" do
    assert_difference('Oauth.count') do
      post :create, oauth: { account: @oauth.account, kind: @oauth.kind, secret: @oauth.secret, token: @oauth.token, user_id: @oauth.user_id }
    end

    assert_redirected_to oauth_path(assigns(:oauth))
  end

  test "should show oauth" do
    get :show, id: @oauth
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @oauth
    assert_response :success
  end

  test "should update oauth" do
    patch :update, id: @oauth, oauth: { account: @oauth.account, kind: @oauth.kind, secret: @oauth.secret, token: @oauth.token, user_id: @oauth.user_id }
    assert_redirected_to oauth_path(assigns(:oauth))
  end

  test "should destroy oauth" do
    assert_difference('Oauth.count', -1) do
      delete :destroy, id: @oauth
    end

    assert_redirected_to oauths_path
  end
end
