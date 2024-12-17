require "simplecov"

SimpleCov.profiles.define("warren") do
  add_filter "spec/spec_helper.rb"
  add_filter "spec/rails_helper.rb"
  add_filter "spec/support"
  add_filter "/config/"
  add_filter "/vendor/"
  add_group "Models", "app/models"
  add_group "Controllers" do |src_file|
    src_file.filename.include?("/app/controllers") &&
      !src_file.filename.include?("/app/controllers/admin")
  end
  add_group "Helpers", "app/helpers"
  add_group "Jobs", "app/jobs"
  add_group "Libs", "app/lib"
  add_group "Serializers", "app/serializers"
  add_group "Admin controllers", "app/controllers/admin"
  add_group "Dashboards", "app/dashboards"
  add_group "Specs", "spec"
end
