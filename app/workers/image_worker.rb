class ImageWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily(1) }

  def perform
    destroy_useless_images
  end

  def destroy_useless_images
    Image.destroy_useless_images
    ImagesMailer.success_removing(User.first).deliver
  end
end