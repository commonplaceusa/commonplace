class TagsController < CommunitiesController

  def index
    @goods = ActsAsTaggableOn::Tagging.all(:conditions => {:context => "goods"}).map(&:tag).map(&:canonical_tag).uniq
    @skills = ActsAsTaggableOn::Tagging.all(:conditions => {:context => "skills"}).map(&:tag).map(&:canonical_tag).uniq
    respond_to do |format|
      format.json
    end
  end

  def new
    respond_to do |format|
      format.json
    end
  end

end
