module DirectoriesHelper

  def entry_options_for(thing)
    options = {"data-info" => render(thing.class.name.pluralize.downcase + "/" + "info_box", :organization => thing)};
    options["data-marker"] = "{\"info_html\": \"#{thing.name}\", \"lat\": \"#{thing.lat}\", \"lng\": \"#{thing.lng}\"}" if thing.lat and thing.lng
    options
  end

end