class Person < ApplicationRecord

    VALID_EMAIL_REGEX = /\A[^@\s]+@([-a-z0-9]+\.)+[a-z]{2,}\z/i

    validates :firstname, presence: true
    validates :lastname, presence: true

    validates :email, presence: true,
        format: { with: VALID_EMAIL_REGEX, message: "incorrect format" },
        length: { minimum: 6, maximum: 128 },
        uniqueness: { case_sensitive: false }

    validates :password,
        presence: true,
        length: { minimum: 8, maximum: 256 }

    # digests the password
    has_secure_password

    # Get the full name of a person
    # Params:
    # +initials+:: bool  ->   true: J. Smith / false: John Smith
    def full_name(initials = false)
        if (initials)
            self[:firstname][0,1] + '. ' + self[:lastname]
        else
            self[:firstname] + ' ' + self[:lastname]
        end
    end

    ##################################################
    #    PERSON STATUS
    ##################################################

    # Checks if the user has the status editor
    def is_editor?
        self[:status] == 'editor'
    end

    # Checks if the user has the status admin
    def is_admin?
        self[:status] == 'admin' || self[:status] == 'editor'
    end

    # Checks if the user has the status researcher
    def is_researcher?
        self[:status] == 'researcher'
    end


    ##################################################
    #    RELATIONS TO PAPERS
    ##################################################

    # Get all the papers written by a person
    def get_papers
      list = Array.new()
      authors = Author.where(person_id: self[:id])
      authors.each do |write|
        list.push(Paper.where(id: write.paper_id).take)
      end
      return list
    end


    # Returns true if the user wrote the paper
    def wrote?(paper)
      paper.get_authors.include? self
    end

    # Returns true if the user has to review the paper
    def should_review?(paper)
      review = paper.get_review_by(self)
      !review.nil? && ['pending', '1'].include?(review[:status])
    end

    # Returns true if the user should review the paper
    def is_reviewing?(paper)
      review = paper.get_review_by(self)
      !review.nil? && ['ongoing', '2'].include?(review[:status])
    end

    # Returns true if the user reviewed the paper
    def reviewed?(paper)
      review = paper.get_review_by(self)
      !review.nil? && ['done', '3'].include?(review[:status])
    end

    # Returns true if the user is reviewer of the paper
    def is_reviewer_of?(paper)
      paper.get_review_by(self)
    end


    # private

      # def is_reviewer_of(paper)?
      #   paper.get_review_by(self)
      # end

    # end

end
