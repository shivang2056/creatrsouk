class AttachmentsController < ApplicationController
  before_action :set_product
  before_action :set_attachment, only: [:destroy]

  def index
    @attachment_decorator = AttachmentDecorator.decorate(@product)
  end

  def create
    attachment = @product
                  .attachments
                  .new(attachment_params)

    if attachment.save
      flash[:notice] = "Attachment added."
    else
      flash[:error] = error_messages(attachment)
    end

    redirect_to generic_product_attachments_path(@product)
  end

  def destroy
    if @attachment.destroy
      flash[:notice] = "Attachment removed."
    else
      flash[:error] = error_messages(@attachment)
    end

    redirect_to generic_product_attachments_path(@product)
  end

  private

  def attachment_params
    params
      .require(:attachment)
      .permit(:file, :name)
  end

  def set_product
    @product = Product
                .includes(attachments: [file_attachment: :blob])
                .find(params[:generic_product_id])
  end

  def set_attachment
    @attachment = @product
                    .attachments
                    .find(params[:id])
  end
end
