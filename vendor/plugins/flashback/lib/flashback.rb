module Glomp
  module Flashback
    class FlashedHash < ActionController::Flash::FlashHash
      def flashed
        @flashed ||= {}
      end

      def discard(k=nil)
        flashed[k] = self[k]
        super(k)
      end
    end

    # Calling this method in your test sometime after the TestRequest is
    # instantiated and before your first call to an action, will allow you to
    # access the discarded flash variables (those that were _flashed_) during
    # the request processing. Specifically, it will allow you to access the
    # <em>Flash.now</em> variables by name.
    #
    # You will access these discarded variables similar to how you would access
    # <em>Flash.now</em>, but this time via a _flashed_ method. For example:
    #
    #   class FooController < ApplicationController
    #     def create
    #       ...
    #       flash.now[:error] = 'Whoops!' unless params[:foo][:baz]
    #       ...
    #     end
    #   end
    #
    #   class FooControllerTest < ActionController::TestCase
    #     def test_create_should_set_some_flash_now_variable
    #       flashback
    #       get :create, :foo => {:bar => 'hello'}
    #       assert_equal 'Whoops!', flash.flashed[:error]
    #     end
    #   end
    #
    # What you will not have access to via _flashed_ are the normal, 
    # inter-request Flash variables. This is because Flashback is only tracking
    # those flash variables that are _discarded_ during the transaction, which
    # includes all variables passed through <em>Flash.now</em>.
    #
    # If you want _flashed_ available all of the time, then simply call 
    # _flashback_ in the _setup_ method of your TestCase. There are likely 
    # better ways that I hope someone will tell me about, but I just wanted to 
    # get this plugin out-the-door.
    # 
    # The only caveat to Flashback is that if you define your own Flash instance 
    # and pass that to your various process methods (get, post, head, etc.), 
    # your flash will override Flashback's, rendering it useless.
    def flashback
      @request.session['flash'] = FlashedHash.new
    end
  end
end

Test::Unit::TestCase.send(:include, Glomp::Flashback)
