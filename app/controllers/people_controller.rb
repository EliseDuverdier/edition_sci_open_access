class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :edit_password, :update, :destroy]

  before_action :is_editor, only: [:index]
  before_action :is_researcher, only: [:new, :create]


  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # GET /people/1/edit_password
  def edit_password
      @person = current_user
  end

  # PATCH/PUT /people/1/edit_password
  def update_password
    respond_to do |format|
      if @person.update(person_params_edit_password)
        format.html { redirect_to @person, notice: 'Your profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit_password }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        log_in @person
        format.html { redirect_to @person, notice: 'Thanks for joining us!' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Your profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Your profile was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # sign up / log in
    def person_params
      params.require(:person).permit(:email, :password, :firstname, :lastname, :status, :bio, :level, :country, :academia_url, :research_gate_url)
    end

    # for editing one’s profile
    def person_params_edit
      params.require(:person).permit(:firstname, :lastname, :status, :bio, :level, :country, :academia_url, :research_gate_url)
    end

    # for modifying password
    def person_params_edit_password
        params.require(:person).permit(:password)
    end

    # Confirms a logged-in user.
    def logged_in_user
      if !logged_in?
        store_location
        redirect_to login_url, :flash => { :error => "Please log in to access to this page!" }
      elsif @person != current_user
        redirect_to @user, :flash => { :error => "You don’t have access to this page!" }
      end
    end

    # Confirms the logged-in user is an editor.
    def is_editor
      unless logged_in? && current_user.status == 'editor'
        redirect_to root_path, :flash => { :error => "You don’t have access to this page!" }
      end
    end

    # Confirms the logged-in user is an editor.
    def is_researcher
      unless logged_in? && current_user.status == 'researcher'
        redirect_to root_path, :flash => { :error => "You don’t have access to this page!" }
      end
    end


end
