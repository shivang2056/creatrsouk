module ReviewConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_user_purchase
    before_action :set_review, only: [:edit, :update]
  end

  def create
    @review = @user_purchase.build_review(review_params)

    if @review.save
      handle_review_save("Review Posted.")
    else
      handle_review_error
    end
  end

  def edit
    render turbo_stream: turbo_stream_update("review", "reviews/form",
      {
        review: @review,
        submit_label: "Edit Review"
      }
    )
  end

  def update
    if @review.update(review_params)
      handle_review_save("Review Updated.")
    else
      handle_review_error
    end
  end

  private

  def handle_review_save(flash_notice)
    flash.now[:notice] = flash_notice

    render turbo_stream: [
      turbo_stream_update("notification", "shared/notification"),
      turbo_stream_update("review", "reviews/show", { review: @review })
    ]
  end

  def handle_review_error
    flash.now[:error] = error_messages(@review)

    render turbo_stream: turbo_stream_update("notification", "shared/notification")
  end

  def set_user_purchase
    @user_purchase = UserPurchase.find(params[:user_purchase_id])
  end

  def set_review
    @review = @user_purchase.review
  end

  def review_params
    params
      .require(:review)
      .permit(:rating, :comment)
  end
end
