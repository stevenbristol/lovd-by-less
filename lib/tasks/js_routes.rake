debug = true


def build_params segs, others = ''
  s = []
  segs.each do |seg|
    if seg.is_a?(ActionController::Routing::DynamicSegment)
      s << seg.key.to_s.gsub(':', '')
    end
  end
  s <<( others) unless others.blank?
  s.join(', ')
end

def build_path segs
  s = ""
  segs.each do |seg|
    if seg.is_a?(ActionController::Routing::DividerSegment) || seg.is_a?(ActionController::Routing::StaticSegment)
      s << seg.instance_variable_get(:@value) 
    elsif seg.is_a?(ActionController::Routing::DynamicSegment)
      s << "' + #{seg.key.to_s.gsub(':', '')} + '"
    end
  end
  s
end

def get_method route
  route.instance_variable_get(:@conditions)[:method] == :get ? 'GET' : 'POST'
end
def get_params route, others = ''
  x = ''
  x += "'_method=#{route.instance_variable_get(:@conditions)[:method]}'" unless [:get, :post].include? route.instance_variable_get(:@conditions)[:method]
  x += " + " unless x.blank? || others.blank?
  x += "#{others}" unless others.blank?
  x
end

def get_js_helpers
  <<-JS
  function get_params(obj){
    for (prop in obj){
      console.log(prop + ": " + obj[prop]);
    }
  }
JS
end





desc "Make a js file that will have functions that will return restful routes/urls."
task :js_routes => :environment do
  s = get_js_helpers
  ActionController::Routing::Routes.routes.each do |route|
    name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
    next if name.blank?
    s << "/////\n//#{route}\n" if debug
    s << <<-JS
function #{name}_path(#{build_params route.segments}){ return '#{build_path route.segments}';}
function #{name}_ajax(#{build_params route.segments, 'params'}){ 
  return jQuery.ajax({
    url: '#{build_path route.segments}',
    type: '#{get_method route}',
    params: #{get_params route, 'params'}
  });
}
JS
  end
  File.open(RAILS_ROOT + '/public/javascripts/less_routes.js', 'w') do |f|
    f.write s
  end
end
=begin
<ActionController::Routing::Route:0x3424ea8 @requirements={:controller=>"admin_users", :action=>"index"}, 
@defaults={:controller=>"admin_users", :action=>"index"}, 
@optimise=true, 
@segments=[#<ActionController::Routing::DividerSegment:0x3425678 @raw=true, @is_optional=false, @value="/">, 
<ActionController::Routing::StaticSegment:0x3425574 @is_optional=false, @value="admin_users">, 
<ActionController::Routing::DividerSegment:0x3425420 @raw=true, @is_optional=false, @value=".">, 
<ActionController::Routing::DynamicSegment:0x3425394 @is_optional=false, @key=:format>, 
<ActionController::Routing::DividerSegment:0x342522c @raw=true, @is_optional=true, @value="/">], 
@conditions={:method=>:get}, 
@to_s="GET    /admin_users.:format/                    {:controller=>\"admin_users\", :action=>\"index\"}", 
@significant_keys=[:format, :controller, :action]>
=end
#  # 
#   @segments=[
# <ActionController::Routing::DividerSegment:0x3417f50 @raw=true, @is_optional=false, @value="/">, 
# <ActionController::Routing::StaticSegment:0x3417e4c @is_optional=false, @value="admin_users">, 
# <ActionController::Routing::DividerSegment:0x3417cf8 @raw=true, @is_optional=false, @value="/">, 
# <ActionController::Routing::DynamicSegment:0x3417c6c @regexp=/[^\/.?]+/, @is_optional=false, @key=:id>, 
# <ActionController::Routing::DividerSegment:0x3417b04 @raw=true, @is_optional=false, @value="/">, 
# <ActionController::Routing::StaticSegment:0x3417a00 @is_optional=false, @value="edit">, 
# <ActionController::Routing::DividerSegment:0x34178ac @raw=true, @is_optional=false, @value=".">, 
# <ActionController::Routing::DynamicSegment:0x3417820 @is_optional=false, @key=:format>, 
# <ActionController::Routing::DividerSegment:0x34176b8 @raw=true, @is_optional=true, @value="/">]