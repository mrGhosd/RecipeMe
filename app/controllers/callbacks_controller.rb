class CallbacksController < ApplicationController
  before_action :load_callback, except: [:index, :create]
  after_action :send_callback_create_message, only: :create

  def index
    @callbacks = ::Callback.all
    render json: @callbacks.as_json
  end

  def create
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
    if @callback.update(callback_params)
      render json: @callback.as_json, status: :ok
    else
      render json: @callback.errors.as_json, status: :unprocessible_entity
    end
  end

  def destroy
    @callback.destroy
    head :ok
  end

  private

  def send_callback_create_message
    msg = { resource: 'Callback',
            action: 'create',
            id: @callback.id,
            obj: @callback
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def callback_params
    params.require(:callback).permit(:author, :user_id, :text)
  end

  def load_callback
    @callback = ::Callback.find(params[:id])
  end
end