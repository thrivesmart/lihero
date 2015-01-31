require 'test_helper'

class OrgUserPrivilegesControllerTest < ActionController::TestCase
  setup do
    @org_user_privilege = org_user_privileges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:org_user_privileges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create org_user_privilege" do
    assert_difference('OrgUserPrivilege.count') do
      post :create, org_user_privilege: { creator_id: @org_user_privilege.creator_id, organization_id: @org_user_privilege.organization_id, privileges: @org_user_privilege.privileges, user_id: @org_user_privilege.user_id }
    end

    assert_redirected_to org_user_privilege_path(assigns(:org_user_privilege))
  end

  test "should show org_user_privilege" do
    get :show, id: @org_user_privilege
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @org_user_privilege
    assert_response :success
  end

  test "should update org_user_privilege" do
    patch :update, id: @org_user_privilege, org_user_privilege: { creator_id: @org_user_privilege.creator_id, organization_id: @org_user_privilege.organization_id, privileges: @org_user_privilege.privileges, user_id: @org_user_privilege.user_id }
    assert_redirected_to org_user_privilege_path(assigns(:org_user_privilege))
  end

  test "should destroy org_user_privilege" do
    assert_difference('OrgUserPrivilege.count', -1) do
      delete :destroy, id: @org_user_privilege
    end

    assert_redirected_to org_user_privileges_path
  end
end
