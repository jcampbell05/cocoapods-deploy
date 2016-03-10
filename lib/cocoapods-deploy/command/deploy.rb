module Pod
  class Command
    class Deploy < Command

      include Project

      # The trasformer to use for transforming dependencies in the Podfile
      # against the lockfile.
      attr_accessor :transformer

      self.summary = 'Install project dependencies to Podfile.lock versions without pulling down full podspec repo.'

      self.description = <<-DESC
        Install project dependencies to Podfile.lock versions without pulling down full podspec repo.
      DESC

      # This method sets up the environment to be optimised
      # for CocoaPod Deployment.
      #
      # Turning off things like repo cloning, clean-up and statistics.
      def setup_environment
        # Disable Cocoapods Stats - Due to
        # https://github.com/CocoaPods/cocoapods-stats/issues/28
        ENV['COCOAPODS_DISABLE_STATS'] = "1"

        # Disable updating of the CocoaPods Repo since we are directly
        # deploying using Podspecs
        config.skip_repo_update = true

        # Disable cleaning of the source file since we are deploying
        # and we don't need to keep things clean.
        config.clean = false
      end

      # Verify the environment is ready for deployment
      # i.e Do we have a podfile and lockfile.
      def verify_environment
        verify_podfile_exists!
        verify_lockfile_exists!
      end

      def create_transformer_for_lockfile
        @transformer = DeployTransformer.new(config.lockfile)
      end

      # This prepares the Podfile and Lockfile for deployment
      # by transforming Repo depedencies to Poddpec based dependencies
      # and making sure we have eveything we need for Subspecs which
      # typially don't work with Podspec based depedencies.
      def prepare_for_deployment

        create_transformer_for_lockfile unless @transformer
        @transformer.transform_podfile(config.podfile)

        # podfile = config.podfile
        # target_definitions = podfile.to_hash["target_definitions"]
        # puts podfile.to_hash["target_definitions"]

        #return

        # - Look at the Podfile
        #   - Verify against Lockfile
        #   - Transform Repo Dependencies to Podspec Ones

        # UI.puts("- Deploying Pods")
        #
        # config.lockfile.pod_names.each do |pod|
        #   version = config.lockfile.version(pod)
        #   UI.puts("- Deploying #{pod} #{version}")
        #   transform_pod_and_version(pod, version)
        # end
      end

      def run
        setup_environment
        verify_environment

        prepare_for_deployment

        #TODO: Somehow use a custom dependencies_to_lock_pod_named in the lockfile
        #TODO: Work out way of transforming dependencies without patch
        # apply_dependency_patches
        #
        # installer = DeployInstaller.new(config.sandbox, config.podfile, config.lockfile)
        # installer.update = update
        # installer.install!
      end
    end
  end
end
