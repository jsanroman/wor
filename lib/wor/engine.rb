module Wor
  class Engine < ::Rails::Engine
    mattr_accessor :site_name, default: "Site Name"
    mattr_accessor :current_user_method, default: :current_user
    mattr_accessor :disqus_api_secret
    mattr_accessor :disqus_api_key
    mattr_accessor :disqus_access_token
    mattr_accessor :disqus_forum
    mattr_accessor :post_layouts, default: [:show]

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    initializer "disqus_config" do |app|
      DisqusApi.config = {api_secret:   Wor::Engine.disqus_api_secret,
                          api_key:      Wor::Engine.disqus_api_key,
                          access_token: Wor::Engine.disqus_access_token}
    end

    initializer :assets do |app|
      app.config.assets.precompile += ["wor/admin/admin.css", "wor/admin/admin.js"]
      app.config.assets.precompile += ["wor/elfinder.css", "wor/elfinder.js"]
      app.config.assets.precompile += ["tinymce/skins/lightgray/content.min.css"]
      app.config.assets.precompile += ["wor/*.png", "wor/*.giff"]
    end

    # Move setup method here
    def self.setup(&block)
      yield self
    end
  end
end
