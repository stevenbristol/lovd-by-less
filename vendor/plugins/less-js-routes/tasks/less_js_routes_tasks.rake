
namespace :less do
  namespace :js do
    desc "Make a js file that will have functions that will return restful routes/urls."
    task :routes => :environment do
      require File.join(File.dirname(__FILE__), "../lib/less/js_routes.rb")
      Less::JsRoutes.generate!
    end
  end
end