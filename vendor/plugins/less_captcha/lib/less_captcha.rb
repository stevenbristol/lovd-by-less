module Less
  module Captcha
    SALT = 'less_salt'
    SUFFIX = '_answer'
    PREFIX = 'captcha'

    module Validations
      def self.append_features(base)
        super
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Validates whether the value of the specified attribute passes the captcha challenge
        #
        #   class User < ActiveRecord::Base
        #     validates_captcha
        #   end
        #
        # Configuration options:
        # * <tt>message</tt> - A custom error message (default is: " did not match valid answer")
        # * <tt>on</tt> Specifies when this validation is active (default is :create, other options :save, :update)
        # * <tt>if</tt> - Specifies a method, proc or string to call to determine if the validation should
        #   occur (e.g. :if => :allow_validation, or :if => Proc.new { |user| user.signup_step > 2 }).  The
        #   method, proc or string should return or evaluate to a true or false value.
        def validates_captcha(options = {})
          attr_accessor PREFIX.to_sym, (PREFIX + SUFFIX).to_sym

          configuration = { :message => ' did not match valid answer', :on => :create }

          configuration.merge!(options)

          validates_each(PREFIX, configuration) do |record, attr_name, value|
            value ||= ''
            record.errors.add(attr_name, configuration[:message]) unless record.send(PREFIX + SUFFIX) == Digest::SHA1.hexdigest(SALT + value)
          end
        end
      end
    end

    module InstanceMethods
      # Sets up the passing answer for the captcha challenge
      #
      #   setup_captcha 'foo'
      #
      # options:
      # * <tt>answer</tt> - The passing answer for the captcha challenge
      def setup_captcha(answer)
        send(PREFIX + SUFFIX + '=', Digest::SHA1.hexdigest(SALT + answer.to_s))
      end
    end

    module Helper
      # Use this helper to create a captcha challenge question
      #
      #   <%= captcha_field("entry") %>
      #
      # the following HTML will be generated. The hidden field contains an encrypted version of the answer
      #
      #   <label for="entry_captcha">What is ...</label>
      #   <input type="hidden" id="entry_captcha_answer" name="entry[captcha_answer]" value="..." />
      #   <input type="text" id="entry_captcha" name="entry[captcha]" />
      #
      # You can use the +options+ argument to pass additional options to the text-field tag.
      def captcha_field(object_name, options={})
        b = rand(10) + 1
        a = b + rand(10)
        op = ['+', '-'][rand(2)]
        question = "What is #{a} #{op} #{b}?"
        answer = a.send(op, b)
        eval("@"+object_name.to_s).setup_captcha(answer)

        returning("") do |result|
          result << ActionView::Helpers::InstanceTag.new(object_name, PREFIX, self).to_label_tag(question, {})
          result << ActionView::Helpers::InstanceTag.new(object_name, PREFIX + SUFFIX, self).to_input_field_tag("hidden", {})
          result << ActionView::Helpers::InstanceTag.new(object_name, PREFIX, self).to_input_field_tag("text", options)
        end
      end
    end
  end
end
