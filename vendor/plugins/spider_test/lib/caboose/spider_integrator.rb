require 'caboose'

module Caboose::SpiderIntegrator


  def debug url
    return unless @debug
    puts "visiting #{url}"
  end
  
  
  
  def consume_page( html, url )
    body = HTML::Document.new html
    body.find_all(:tag=>'a').each do |tag|
 #     puts "FOUND: #{tag}, #{url}"
      queue_link( tag, url )
    end
    body.find_all(:tag =>'form').each do |form|
      queue_form( form, url )
    end
  end
  
  def spider( body, uri, debug = false )
    @debug = debug
    @links_to_visit, @forms_to_visit = [], []
    @visited_uris = { '/logout' => true }
    @visited_forms = { '/login' => true }
    @visited_uris[uri] = true
    @errors = []

    consume_page( body, uri )
    until @links_to_visit.empty?
      next_link = @links_to_visit.shift
      next if @visited_uris[next_link.uri]
      # puts next_link.uri

      if next_link.uri =~ /\.(html|png|jpg|gif)$/ # static file, probably.
        if File.exist?("#{RAILS_ROOT}/public/#{next_link.uri}")
          @response.body = File.open("#{RAILS_ROOT}/public/#{next_link.uri}").read
          printf "."
        else
          printf "?"
          @errors << "File not found: #{next_link.uri} from #{next_link.source}"
        end
      else
        debug next_link.uri
        get next_link.uri
        if @response.nil?
          puts 'nil'
#          puts next_link.uri
          next 
        end
        puts( 't') if next_link.uri == 'http://www.example.com/admin_themed_searches'
        if %w( 200 302 401 ).include?( @response.code )
          printf '.'
        elsif @response.code == 404
          printf '?'
        else
          printf '!'
          @errors << "Received response code #{ @response.code } for URI #{ next_link.uri } from #{ next_link.source }"
          debug @response.body
        end
      end
      consume_page( @response.body, next_link.uri )
      @visited_uris[next_link.uri] = true
    end

    puts "\nTesting forms.."
    until @forms_to_visit.empty?
      next_form = @forms_to_visit.shift
      next if @visited_forms[next_form[:action]]
      # puts "#{next_form[:method]} : #{next_form[:action]} with #{next_form[:query].inspect}"
      printf '.'
      debug "FORM: method: #{next_form[:method]}, action: #{next_form[:action]}, query: #{next_form[:query]}"
      send(next_form[:method], next_form[:action], next_form[:query]) rescue nil
      unless %w( 200 302 401 ).include?( @response.code )
        @errors << "Received response code #{ @response.code } for URI #{ next_form[:action] } from #{ next_form[:source] }"
        debug @response.body
      end
      consume_page( @response.body, next_form[:action] )
      @visited_forms[next_form[:action]] = true
    end
    assert @errors.empty?, "\n\n=========================\n#{@errors.join("\n")}\n======================"
  end









  # Adds all <a href=..> links to the list of links to be spidered.
  # If it finds an Ajax.Updater url, it'll call that too.
  def queue_link( tag, source )
    return if tag.attributes['class'] && tag.attributes['class']['thickbox'] == 'thickbox'
    return if tag.attributes['onclick']
    dest = (tag.attributes['onclick'] =~ /^new Ajax.Updater\(['"].*?['"], ['"](.*?)['"]/i) ? $1 : tag.attributes['href']
    if !(dest =~ %r{^(mailto:|#|javascript:|http://|.*\.jpg|aim:|ichat:|xmpp:)})
      @links_to_visit << Link.new( dest, source )
    end
  end
  
  
  
  
  
  
  
  
  def create_data(input)
    case input['name']
    when /amount/: rand(10000) - 5000
    when /uploaded_data/: # attachment_fu
      nil
    else
      rand(10000).to_s
    end
  end
  
  
  
  
  
  
  
  
  def queue_form( form, source )
    form_method = form['method']
    form_action = form['action']
    form_action = source if form_action.nil? or form_action.empty?
    debug "VOID ACTION from: #{source}" if form['action'] == "javascript:void(0)"

    input_hash = {}
    form.find_all(:tag => 'input').each do |input|
      if input['name'] == '_method' # and value.in?['put','post',..] # rails is faking the post/put etc
        form_method = input['value']
      elsif input['name'] &&input['name']['_temp]'] == '_temp]'
          input_hash[ input['name'] ] = ''
      else
        if input['type'] == 'hidden'
          input_hash[ input['name'] ] = create_data(input)
        else
          input_hash[ input['name'] ] = input['value'] || create_data(input)
        end
        if input['type'] == 'file'
          input_hash[ input['name'] ] = ''
        end
      end
    end
    form.find_all(:tag => 'textarea').each do |input|
      input_hash[ input['name'] ] = input['value'] || create_data(input)
    end
    form.find_all(:tag => 'select').each do |input|
      input_hash[ input['name'] ] = input.find_all(:tag=>'option').rand['value'] rescue nil
    end

    @forms_to_visit << { :method => form_method, :action => form_action, :query => input_hash, :source => source }
  end

  Link = Struct.new( :uri, :source )

end 