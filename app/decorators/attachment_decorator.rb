class AttachmentDecorator
  include ActiveSupport::NumberHelper
  include Rails.application.routes.url_helpers
  include ActiveStorageSetCurrent

  def initialize(product)
    @product = product
  end

  def self.decorate(product)
    new(product)
  end

  def attachments
    @product.attachments.reorder(created_at: :asc).map { |attachment| attachment_details(attachment) }
  end

  private

  def attachment_details(attachment)
    {
      name: attachment.name,
      type: attachment_type(attachment),
      size: attachment_size(attachment),
      download_path: attachment_download_path(attachment),
      delete_path: attachment_delete_path(attachment)
    }
  end

  def attachment_type(attachment)
    content_type = attachment.file.blob.content_type

    extension = Marcel::EXTENSIONS.key(content_type)
    extension.upcase
  end

  def attachment_size(attachment)
    number_to_human_size(attachment.file.byte_size)
  end

  def attachment_download_path(attachment)
    if Rails.env.production?
      attachment.file.url
    else
      rails_blob_path(attachment.file, disposition: 'attachment')
    end
  end

  def attachment_delete_path(attachment)
    generic_product_attachment_path(@product.id, attachment.id)
  end
end
