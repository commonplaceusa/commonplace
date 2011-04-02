class InternshipsController < ApplicationController
  # GET /internships
  # GET /internships.xml
  def index
    @internships = Internship.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @internships }
    end
  end

  # GET /internships/1
  # GET /internships/1.xml
  def show
    @internship = Internship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @internship }
    end
  end

  # GET /internships/new
  # GET /internships/new.xml
  def new
    @internship = Internship.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @internship }
    end
  end

  # GET /internships/1/edit
  def edit
    @internship = Internship.find(params[:id])
  end

  # POST /internships
  # POST /internships.xml
  def create
    @internship = Internship.new(params[:internship])

    respond_to do |format|
      if @internship.save
        format.html { redirect_to(@internship, :notice => 'Internship was successfully created.') }
        format.xml  { render :xml => @internship, :status => :created, :location => @internship }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @internship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /internships/1
  # PUT /internships/1.xml
  def update
    @internship = Internship.find(params[:id])

    respond_to do |format|
      if @internship.update_attributes(params[:internship])
        format.html { redirect_to(@internship, :notice => 'Internship was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @internship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /internships/1
  # DELETE /internships/1.xml
  def destroy
    @internship = Internship.find(params[:id])
    @internship.destroy

    respond_to do |format|
      format.html { redirect_to(internships_url) }
      format.xml  { head :ok }
    end
  end
end
