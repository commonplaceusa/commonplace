class Administration::FeedsController < AdministrationController

  def index
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(params[:feed])
    if @feed.save
      redirect_to :index
    else
      render :new
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end
                                      
  def update
    @feed = Feed.find(params[:id])
    if @feed.update_attributes(params[:feed])
      redirect_to feeds_path
    else
      render :edit
    end
  end
    
end
