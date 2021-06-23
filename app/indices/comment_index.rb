ThinkingSphinx::Index.define :comment, with: :active_record do
  #fields
  indexes body, sortable: true

  #attributes
  has created_at, updated_at
end
