CONFIG = Rails.root.join("config", "config.yml").open{ |file| YAML::load(file) }
