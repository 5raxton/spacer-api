class FlashcardsController < ApplicationController

  # returns a list with all the filtered flashcards
  def index
    # this should be current user
    user = User.first
    @flashcards = user.filtered_flashcards(params[:filter])
  end

  # creates a bunch of flashcards
  def create
    # this should be current user
    user = User.first
    error_messages = []

    flashcards_bundle_params[:_json].each do |flashcard|
      f = user.flashcards.build(flashcard)

      unless f.save
        error_messages << f.errors.full_messages
      end
    end

    if error_messages.any?
      render json: { errors: error_messages.unique }, status: :accepted
    else
      head :ok
    end
  end

  # edits a bunch of flashcards
  def update
    # this should be current user
    user = User.first
    error_messages = []

    flashcards_bundle_update_params[:_json].each do |flashcard|
      f = Flashcard.find(flashcard[:id])

      f_temp = user.flashcards.build(
        front: flashcard[:front],
        back: flashcard[:back]
      )

      if f_temp.valid?
        f.update(front: flashcard[:front], back: flashcard[:back])
      else
        error_messages << f_temp.errors.full_messages
      end
    end

    if error_messages.any?
      render json: { errors: error_messages.unique }, status: :accepted
    else
      head :ok
    end
  end

  private

  def flashcards_bundle_params
    params.permit(_json: [:front, :back])
  end

  def flashcards_bundle_update_params
    params.permit(_json: [:id, :front, :back])
  end

end

