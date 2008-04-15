require File.join(File.dirname(__FILE__), '../../../../test/test_helper')
require 'test/unit'

class Thing < ActiveRecord::Base
  validates_captcha :if => Proc.new {|o| o.name != 'stevebristol'}
  
  attr_accessor :name
  
  def initialize(n) 
    self.name = n 
  end
end

class LessCaptchaTest < Test::Unit::TestCase
  def setup 
    @thing = Thing.new('thing') 
  end

  def test_captcha_methods
    assert @thing.respond_to?('captcha')
    assert @thing.respond_to?('captcha_answer')
  end
  
  def test_captcha_with_if
    @thing = Thing.new('stevebristol')

    @thing.setup_captcha 'foo'
    @thing.captcha = nil
    assert @thing.valid? 

  end

  def test_question_validation
    @thing.setup_captcha 'foo'
    
    assert !@thing.valid?
    
    @thing.captcha = nil
    assert !@thing.valid?
    
    @thing.captcha = ''
    assert !@thing.valid?
    
    @thing.captcha = 'bar'
    assert !@thing.valid?
    
    @thing.captcha = 'foo'
    assert @thing.valid?
  end
end
