require_relative 'base'

module AppInsights
  class SinatraInstaller < Sinatra::Application
    def self.root
      File.dirname app_file
    end

    def self.init(root, filename = nil)
      installer = AppInsights::Base.new Sinatra::Application,
                                        root,
                                        filename

      installer.install
    end

    # This will call the init method as soon as this file is required
    SinatraInstaller.init SinatraInstaller.root
  end
end
