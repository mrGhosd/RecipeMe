class CallbacksController < ApplicationController
  before_action :load_callback, except: [:index, :create]

  def index
    @callbacks = ::Callback.all
    render json: @callbacks.as_json
  end

  def create
    binding.pry
    @callback = ::Callback.new(callback_params)
    if @callback.save
      render json: @callback.as_json, status: :ok
    else
      render json: @callback.errors.to_json, status: :uprocessible_entity
    end
  end

  def show

  end

  def update

  end

  def destroy
    @callback.destroy
    head :ok
  end

  private

  def callback_params
    params.require(:callback).permit(:author, :user_id, :text)
  end

  def load_callback
    @callback = ::Callback.find(params[:id])
  end
end