ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes body

  # attributes
  has user_id, answer_id, question_id, created_at, updated_at
end