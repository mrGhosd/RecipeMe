ThinkingSphinx::Index.define :recipe, with: :active_record do

  #fields
  indexes title, sortable: true
  indexes description
  indexes user.email, as: :author
  indexes tags.name, as: :tag

  #attributes
  has user_id, created_at, updated_at

  set_property enable_star: 1
  set_property min_infix_len: 1
end