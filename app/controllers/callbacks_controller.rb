class CallbacksController < ApplicationController
  before_action :load_callback, except: [:index, :create]

  def index
    @callbacks = ::Callback.all
    render json: @callbacks.as_json
  end

  def create

  end

  def show

  end

  def update

  end

  def destroy

  end

  private

  def callback_params

  end

  def load_callback
    @callback = Callback.find(params[:id])
  end
end