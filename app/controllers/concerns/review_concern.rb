module ReviewConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_user_purchase
    before_action :set_review, only: [:edit, :update]
  end

  def create
    @review = @user_purchase.build_review(review_params)

    if @review.save
      flash.now[:notice] = "Review Posted."

      render turbo_stream: [
        turbo_stream_update("notification", "shared/notification"),
        turbo_stream_update("review", "reviews/show", { review: @review })
      ]
    else
      flash.now[:error] = @review.errors.full_messages.join(', ')

      render turbo_stream: [
        turbo_stream_update("notification", "shared/notification")
      ]
    end
  end

  def edit
    render turbo_stream: [
      turbo_stream_update("review", "reviews/form",
        {
          review: @review,
          submit_label: "Edit Review"
        }
      )
    ]
  end

  def update
    if @review.update(review_params)
      flash.now[:notice] = "Review Updated."

      render turbo_stream: [
        turbo_stream_update("notification", "shared/notification"),
        turbo_stream_update("review", "reviews/show", { review: @review })
      ]
    else
      flash.now[:error] = @review.errors.full_messages.join(', ')

      render turbo_stream: [
        turbo_stream_update("notification", "shared/notification")
      ]
    end
  end

  private

  def set_user_purchase
    @user_purchase = UserPurchase.find(params[:user_purchase_id])
  end

  def set_review
    @review = @user_purchase.review
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
