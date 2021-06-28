ThinkingSphinx::Index.define :question, with: :active_record do
  #fields
  indexes title, sortable: true
  indexes body

  #attributes
  has created_at, updated_at
end
