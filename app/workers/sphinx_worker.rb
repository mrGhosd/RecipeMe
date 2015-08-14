class ImageWorker
  include Sidekiq::Worker

  def perform
    
  end

  def self.ts_delta(delta)
    binding.pry
  end
end