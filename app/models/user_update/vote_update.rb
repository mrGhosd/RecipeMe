class VoteUpdate < UserUpdate
  after_create :set_message

  def set_message

  end
end