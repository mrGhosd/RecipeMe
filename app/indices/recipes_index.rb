ThinkingSphinx::Index.define :recipe, with: :active_record, delta: ThinkingSphinx::Deltas::SidekiqDelta do
  #fields
  indexes title, sortable: true
  indexes description
  indexes user.nickname, as: :author
  indexes tags.name, as: :tag
  indexes ingridients.name, as: :ingridient

  #attributes
  has user_id, created_at, updated_at

  set_property enable_star: 1
  set_property min_infix_len: 1

  set_property delta: ThinkingSphinx::Deltas::SidekiqDelta
end