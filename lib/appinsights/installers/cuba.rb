require_relative 'base'

module AppInsights
  class CubaInstaller
    def self.init(root, filename = nil)
      installer = AppInsights::BaseInstaller.new Cuba.app, root, filename
      installer.install
    end

    def self.installation_message
      <<-EOS
        Cuba framework does not keep the root path of the application.
        The automatic installation can not continue. Please configure by your own
        using the following code or doing a manual installation:

            AppInsights::CubaInstaller.init application_root_path

      EOS
    end
  end
end

