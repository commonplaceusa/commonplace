module UpdateHelper

  def update_content(name, content = nil, &block)
    @_updated_content ||= Hash.new
    content = block_given? ? capture(&block) : "none"
    @_updated_content[name] = content || ""
  end

  def updated_content
    @_updated_content || Hash.new
  end

  def updated_content_or(key, &default)
    updated_content.has_key?(key) ? updated_content[key] : capture(&default)
  end

  def trigger(event, options, &block)
    @_js_events ||= Hash.new
    options[:content] ||= block_given? ? capture(&block) : ""
    @_js_events[event] = options
  end

  def triggers
    @_js_events ||= Hash.new
  end
end
