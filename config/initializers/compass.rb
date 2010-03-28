require 'compass'
# If you have any compass plugins, require them here.
Compass.add_project_configuration(File.join(defined?(Rails) ? Rails.root : RAILS_ROOT, "config", "compass.rb"))
Compass.configuration.environment = (defined?(Rails) ? Rails.env : RAILS_ENV).to_sym
Compass.configure_sass_plugin!
  