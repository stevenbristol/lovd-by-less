class LessFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::ActiveRecordHelper
  
  def method_missing *args
    options = args.extract_options!
    label = get_label '', options
    front(label) + super(*args) + back(label)
  end
  
  
  def wrap method, options = {}
    s = front(method, options) 
    s += yield if block_given?
    s += back(method, options)
  end
  
  # Generates a label
  #
  # If +options+ includes :for,
  # that is used as the :for of the label.  Otherwise,
  # "#{this form's object name}_#{method}" is used.
  #
  # If +options+ includes :label,
  # that value is used for the text of the label.  Otherwise,
  # "#{method titleized}: " is used.
  def label method, options = {}
    text = options.delete(:label) ||  "#{method.to_s.titleize}: "
    if options[:for]
      "<label for='#{options.delete(:for)}'>#{text}</label>"
    else
      #need to use InstanceTag to build the correct ID for :for
      ActionView::Helpers::InstanceTag.new(@object_name, method, self, @object).to_label_tag(text, options)
    end
  end
  
  def select method, options = {}
    front(method, options) + super + back(method, options)
  end
  
  def text_field method, options = {}
    front(method, options) + super + back(method, options)
  end
  
  def password_field method, options = {}
    front(method, options) + super + back(method, options)
  end
  
  
  def text_area method, options = {}
    front(method, options) + super + back(method, options)
  end
  
  def check_box method, options = {}
    front(method, options) + super + back(method, options)
  end
  
  
  def calendar_field method, options = {}
    expired = options.delete(:expired) || false
    if not expired; options.merge!(:class => 'calendar'); else; options.merge!(:disabled => true); end
    text_field method, options
  end
  
  def front method = '', options = {}
    "<div class='row clear'>#{label(method, options)}"
  end
  
  def back method = '', options = {}
    <<-EOS   
  	#{error_messages_on( object_name, method  ) unless method.blank?}
  	<div class='clear'></div>
    </div>
    EOS
  end
  
end
