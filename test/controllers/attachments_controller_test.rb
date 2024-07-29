require 'test_helper'

class AttachmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @attachment = attachments(:attachment1)
    @attachment.file.attach(fixture_file_upload('sample.txt'))
    @product = @attachment.product
    @user = users(:user1)

    sign_in @user
  end

  test "should get index" do
    get generic_product_attachments_path(@product)

    assert_response :success
    assert_not_nil assigns(:attachment_decorator)
  end

  test "should create attachment" do
    assert_difference('Attachment.count') do
      post generic_product_attachments_path(@product), params: { attachment: { name: 'New Attachment', file: fixture_file_upload('sample2.txt') } }
    end

    assert_redirected_to generic_product_attachments_path(@product)
    assert_equal 'Attachment added.', flash[:notice]
  end

  test "should not create attachment with invalid params" do
    assert_no_difference('Attachment.count') do
      post generic_product_attachments_path(@product), params: { attachment: { name: '', file: nil } }
    end

    assert_redirected_to generic_product_attachments_path(@product)
    assert_equal "Name can't be blank and File can't be blank", flash[:error]
  end

  test "should destroy attachment" do
    assert_difference('Attachment.count', -1) do
      delete generic_product_attachment_path(@product, @attachment)
    end

    assert_redirected_to generic_product_attachments_path(@product)
    assert_equal 'Attachment removed.', flash[:notice]
  end
end
