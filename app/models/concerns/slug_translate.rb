module SlugTranslate
  def normalize_friendly_id(text)
    text.to_slug.normalize(transliterations: :russian).to_s
  end
end