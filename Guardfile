guard :rspec, cmd: "bin/rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  directories %w[app config lib spec]

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w[erb haml slim])
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(rails.controllers) do |m|
    [
      rspec.spec.call("routing/#{m[1]}_routing"),
      rspec.spec.call("controllers/#{m[1]}_controller"),
      rspec.spec.call("requests/#{m[1]}")
    ]
  end

  # Rails config changes
  watch(rails.spec_helper) { rspec.spec_dir }
  watch(rails.routes) { "#{rspec.spec_dir}/routing" }
  watch(rails.app_controller) { "#{rspec.spec_dir}/controllers" }

  watch(%r{^app/jobs/(.+)\.rb$}) { |m| "spec/jobs/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
end

guard :reek do
  # Watch Ruby files but ignore certain directories
  watch(%r{^app/.+\.rb$})
  watch(%r{^lib/.+\.rb$})
  watch(%r{^spec/.+\.rb$})

  # Ignore certain directories
  ignore(%r{^vendor/})
  ignore(%r{^tmp/})
  ignore(%r{^db/schema\.rb})
  ignore(%r{^db/migrate/})

  # Watch for changes in Reek config
  watch(%r{(?:.+/)?\.reek.yml(?:\.yml)?$})
end
