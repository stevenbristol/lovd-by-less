require 'less'

module Less
  class JsRoutes
    class << self
      
      
      @@debug = false


      def build_params segs, others = ''
        s = []
        segs.each do |seg|
          if seg.is_a?(ActionController::Routing::DynamicSegment)
            s << seg.key.to_s.gsub(':', '')
          end
        end
        s << 'verb'
        s <<( others) unless others.blank?
        s.join(', ')
      end

      def build_path segs
        s = ""
        segs.each_index do |i|
          seg = segs[i]
          break if i == segs.size-1 && seg.is_a?(ActionController::Routing::DividerSegment)
          if seg.is_a?(ActionController::Routing::DividerSegment) || seg.is_a?(ActionController::Routing::StaticSegment)
            s << seg.instance_variable_get(:@value) 
          elsif seg.is_a?(ActionController::Routing::DynamicSegment)
            s << "' + #{seg.key.to_s.gsub(':', '')} + '"
          end
        end
        s
      end

      def get_params others = ''
        x = ''
        x += " + " unless x.blank? || others.blank?
        x += "less_get_params(#{others})" unless others.blank?
        x
      end

      def get_js_helpers
        <<-JS
function less_json_eval(json){return eval('(' +  json + ')')}  

function less_get_params(obj){
  #{'console.log("less_get_params(" + obj + ")");' if @@debug} 
  if (jQuery) { return obj }
  if (obj == null) {return '';}
  var s = [];
  for (prop in obj){
    s.push(prop + "=" + obj[prop]);
  }
  return s.join('&') + '';
}

function less_merge_objects(a, b){
  #{'console.log("less_merge_objects(" + a + ", " + b + ")");' if @@debug} 
  if (b == null) {return a;}
  z = new Object;
  for (prop in a){z[prop] = a[prop]}
  for (prop in b){z[prop] = b[prop]}
  return z;
}

function less_ajax(url, verb, params, options){
  #{'console.log("less_ajax(" + url + ", " + verb + ", " + params +", " + options + ")");' if @@debug} 
  if (verb == undefined) {verb = 'get';}
  var res;
  if (jQuery){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
    #{'console.log("less_merge_objects:v : " + v);' if @@debug} 
    #{'console.log("less_merge_objects:p : " + p);' if @@debug} 
    res = jQuery.ajax(less_merge_objects({async:false, url: url, type: v, data: p}, options)).responseText;
  } else {  
    new Ajax.Request(url, less_merge_objects({asynchronous: false, method: verb, parameters: less_get_params(params), onComplete: function(r){res = r.responseText;}}, options));
  }
  if (url.indexOf('.json') == url.length-5){ return less_json_eval(res);}
  else {return res;}
}
function less_ajaxx(url, verb, params, options){
  #{'console.log("less_ajax(" + url + ", " + verb + ", " + params +", " + options + ")");' if @@debug} 
  if (verb == undefined) {verb = 'get';}
  if (jQuery){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
    #{'console.log("less_merge_objects:v : " + v);' if @@debug} 
    #{'console.log("less_merge_objects:p : " + p);' if @@debug} 
    jQuery.ajax(less_merge_objects({ url: url, type: v, data: p, complete: function(r){eval(r.responseText)}}, options));
  } else {  
    new Ajax.Request(url, less_merge_objects({method: verb, parameters: less_get_params(params), onComplete: function(r){eval(r.responseText);}}, options));
  }
}
JS
      end




      def generate!
        s = get_js_helpers
        ActionController::Routing::Routes.routes.each do |route|
          name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
          next if name.blank?
# s << build_path( route.segments)
# s << "\n"
# s << route.inspect# if route.instance_variable_get(:@conditions)[:method] == :put
          s << "/////\n//#{route}\n" if @@debug
          s << <<-JS
function #{name}_path(#{build_params route.segments}){ return '#{build_path route.segments}';}
function #{name}_ajax(#{build_params route.segments, 'params'}, options){ return less_ajax('#{build_path route.segments}', verb, params, options);}
function #{name}_ajaxx(#{build_params route.segments, 'params'}, options){ return less_ajaxx('#{build_path route.segments}', verb, params, options);}
JS
        end
        File.open(RAILS_ROOT + '/public/javascripts/less_routes.js', 'w') do |f|
          f.write s
        end
      end

    end
  end
end
