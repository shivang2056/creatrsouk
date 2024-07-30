require "test_helper"

class AttachmentDecoratorTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include ActionDispatch::TestProcess

  setup do
    @product = products(:product1)
    @attachment1 = @product.attachments.first
    @attachment1.file.attach(fixture_file_upload("sample.txt"))
    @attachment2 = @product.attachments.create(name: "MyString2", file: fixture_file_upload("image.jpeg"))
    @decorated_product = AttachmentDecorator.decorate(@product)
  end

  test "should return array of attachment details" do
    expected = [
      {
        name: @attachment1.name,
        type: "AART",
        size: "566 Bytes",
        download_path: rails_blob_path(@attachment1.file, disposition: "attachment"),
        delete_path: generic_product_attachment_path(@product.id, @attachment1.id)
      },
      {
        name: @attachment2.name,
        type: "JFI",
        size: "1.67 MB",
        download_path: rails_blob_path(@attachment2.file, disposition: "attachment"),
        delete_path: generic_product_attachment_path(@product.id, @attachment2.id)
      },
    ]

    assert_equal expected, @decorated_product.attachments
  end

end
