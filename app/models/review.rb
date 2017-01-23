class Review < ApplicationRecord

  belongs_to :paper,  foreign_key: "paper_id"
  belongs_to :person, foreign_key: "reviewer_id"
  belongs_to :person, foreign_key: "editor_id"


  def reviewer
    Person.where(id: reviewer_id)
  end

  def editor
    Person.where(id: editor_id)
  end

end
