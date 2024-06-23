class AttachmentDecorator
  include ActiveSupport::NumberHelper
  include Rails.application.routes.url_helpers

  def initialize(product)
    @product = product
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def self.decorate(product)
    self.new(product)
  end

  def attachments
    @product.attachments.map do |attachment|
      {
        name: attachment.name,
        type: attachment_type(attachment),
        size: attachment_size(attachment),
        download_path: attachment_download_path(attachment),
        delete_path: attachment_delete_path(attachment)
      }
    end
  end

  private

  def attachment_type(attachment)
    Marcel::EXTENSIONS.key(attachment.file.blob.content_type).upcase
  end

  def attachment_size(attachment)
    number_to_human_size(attachment.file.byte_size)
  end

  def attachment_download_path(attachment)
    rails_blob_path(attachment.file, disposition: 'attachment')
  end

  def attachment_delete_path(attachment)
    generic_product_attachment_path(@product.id, attachment.id)
  end
end
