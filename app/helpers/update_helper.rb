module UpdateHelper

  def update_content(name, content = nil, &block)
    @_updated_content ||= Hash.new
    content = block_given? ? capture(&block) : "none"
    @_updated_content[name] = content || ""
  end

  def updated_content
    @_updated_content || Hash.new
  end


end
