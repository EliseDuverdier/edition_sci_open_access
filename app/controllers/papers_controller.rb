class PapersController < ApplicationController
  before_action :set_paper,        only: [:show, :edit, :update, :destroy]

  # permissions to access
  before_action :logged_in_author, only: [:edit, :update, :destroy]
  before_action :is_researcher,    only: [:new, :create]
  before_action :is_editor,        only: [:index_pending, :index_refused, :index_all, :validate, :refuse]

  # GET /papers
  def index
    @title = "Published papers"
    @papers = Paper.where(status: 2)
  end

  # GET /papers/pending
  def index_pending
    @title = "Pending papers"
    @papers = Paper.where(status: [-1, 0, 1])
    render :index
  end

  # GET /papers/refused
  def index_refused
    @title = "Refused papers"
    @papers = Paper.where(status: 3)
    render :index
  end

  # GET /papers/all
  def index_all
    @title = "All papers"
    @papers = Paper.all
    render :index
  end


##########################################################

  # GET /papers/1
  # GET /papers/1.json
  def show
  end

  # GET /papers/new
  def new
    @paper = Paper.new
  end

  # GET /papers/1/edit
  def edit
  end


##########################################################

  # POST /papers
  def create
    @paper = Paper.new(paper_params)
    @paper.status = -1 # pending, not reviewed
    @paper.reviews_count = 0

    if @paper.save
      # save author
      @author = Author.new(paper_id: @paper.id, person_id: current_user.id)
      @author.save

      redirect_to @paper, notice: 'Paper was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /papers/1
  def update
    if @paper.update(paper_params)
      redirect_to @paper, notice: 'Paper was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /papers/1
  def destroy
    @paper.destroy
    redirect_to papers_url, notice: 'Paper was successfully destroyed.'
  end

  ######## end of a review round ##################

  # POST /papers/1/accept
  def ask_revision
    @paper.set_review_round_done
    @paper.add_a_review_round
    @paper.update(need_revision: true)
  end

  # POST /papers/1/accept
  def accept
    @paper.set_review_round_done
    @paper.update(status: 2)
  end

  # POST /papers/1/refuse
  def refuse
    @paper.set_review_round_done
    @paper.update(status: 3)
  end




  ##########################################################

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paper_params
      params.require(:paper).permit(:paper_type, :title, :abstract, :tex_content, :html_content, :category_id)
    end

    def author_params
      params.require(:paper_id, :person_id)
    end

    def logged_in_author
      if !logged_in?
        store_location
        redirect_to login_url, :flash => { :error => t('people.unauthorized') }
      elsif !@paper.get_authors.include? current_user
        redirect_to @paper, :flash => { :error => t('paper.edit.forbidden') }
      end
    end

end
