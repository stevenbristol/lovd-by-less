class LessFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::ActiveRecordHelper
  
  def method_missing *args
    options = args.extract_options!
    label = get_label '', options
    front(label) + super(*args) + back(label)
  end
  
  
  def wrap options = {}
    label = options[:label]
    s = front(label) 
    s += yield if block_given?
    s += back(label)
  end
  
  def select method, options = []
    label = get_label method, options
    front(label) + super + back(method)
  end
  
  def text_field method, options = {}
    label = get_label method, options
    front(label) + super + back(method)
  end
  
  def password_field method, options = {}
    label = get_label method, options
    front(label) + super + back(method)
  end
  
  
  def text_area method, options = {}
    label = get_label method, options
    front(label) + super + back(method)
  end
  
  def check_box method, options = {}
    label = get_label method, options
    front(label) + super + back(method)
  end
  
  
  def calendar_field method, options = {}
    expired = options.delete(:expired) || false
    label = get_label method, options
    if not expired; options.merge!(:class => 'calendar'); else; options.merge!(:disabled => true); end
    text_field method, options
  end
  
  
  def front label = '', options = {}
    "<div class='row clear'><label>#{label.to_s.titleize}:</label> "
  end
  
  def back method = '', options = {}
    <<-EOS   
  	#{error_messages_on( object_name, method  ) unless method.blank?}
  	<div class='clear'></div>
    </div>
    EOS
  end
  
  
  protected
  def get_label method, options
    label = options.delete(:label) || method
    label.to_s.titleize
  end
  
end
