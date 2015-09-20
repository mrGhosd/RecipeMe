module SlugTranslate
  extend ActiveSupport::Concern

  included do
    before_save :change_slug
  end

  def change_slug
    self.slug = normalize_friendly_id(self.try(:title) || self.try(:nickname))
  end

  def normalize_friendly_id(text)
    text.to_slug.normalize(transliterations: :russian).to_s if text.present?
  end
end