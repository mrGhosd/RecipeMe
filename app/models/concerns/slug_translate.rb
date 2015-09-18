module SlugTranslate
  extend ActiveSupport::Concern

  before_save :change_slug

  def change_slug
    self.slug = normalize_friendly_id(self.title)
  end

  def normalize_friendly_id(text)
    text.to_slug.normalize(transliterations: :russian).to_s
  end
end