namespace :goenv do
  task validate: :'goenv:wrapper' do
    on release_roles(fetch(:goenv_roles)) do
      goenv_go_version = fetch(:goenv_go_version)
      if goenv_go_version.nil?
        error "goenv: goenv_go_version is not set"
        exit 1
      end

      goenv_version_path = fetch(:goenv_version_path)
      goenv_version_path = [goenv_version_path] unless goenv_version_path.is_a?(Array)

      unless test(goenv_version_path.map {|p| "[ -d #{p} ]" }.join(" || "))
        error "goenv: #{goenv_go_version} is not installed or not found in any of #{goenv_version_path.join(" ")}"
        exit 1
      end
    end
  end

  task :map_bins do
    SSHKit.config.default_env.merge!({ node_version: "#{fetch(:goenv_go_version)}" })
    goenv_prefix = fetch(:goenv_prefix, -> { "#{fetch(:tmp_dir)}/#{fetch(:application)}/goenv-exec.sh" } )
    fetch(:goenv_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(goenv_prefix)
    end
  end

  task :wrapper do
    on release_roles(fetch(:goenv_roles)) do
      execute :mkdir, "-p", "#{fetch(:tmp_dir)}/#{fetch(:application)}/"
      # upload! StringIO.new("#!/bin/bash -e\nsource \"#{fetch(:goenv_path)}/goenv.sh\"\ngoenv use $GO_VERSION\nexec \"$@\""), "#{fetch(:tmp_dir)}/#{fetch(:application)}/goenv-exec.sh"
      upload! StringIO.new("#!/bin/bash -e\nexport GOENV_ROOT=\"$HOME/.goenv\";\nexport PATH=\"$GOENV_ROOT/bin:$PATH\"\neval \"$(goenv init -)\"\ngoenv local $GO_VERSION\nexec \"$@\""), "#{fetch(:tmp_dir)}/#{fetch(:application)}/goenv-exec.sh"
      execute :chmod, "+x", "#{fetch(:tmp_dir)}/#{fetch(:application)}/goenv-exec.sh"
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'goenv:validate'
  after stage, 'goenv:map_bins'
end

namespace :load do
  task :defaults do

    set :goenv_path, -> {
      goenv_path = fetch(:goenv_custom_path)
      goenv_path ||= if fetch(:goenv_type, :user) == :system
        "/usr/local/goenv"
      else
        "$HOME/.goenv"
      end
    }

    set :goenv_roles, fetch(:goenv_roles, :all)
    set :goenv_version_path, -> { ["#{fetch(:goenv_path)}/versions/#{fetch(:goenv_go_version)}"] }
    set :goenv_map_bins, %w{go}
  end
end
