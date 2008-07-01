require 'test/unit'

class TestFake < Test::Unit::TestCase

  def test_true
    assert true
  end

  def test_fail
    assert false
  end

  def test_true_2
    assert true
  end

  def test_true_3
    assert true
  end

  def test_error
    assert method_dont_exist
  end

  def test_true_4
    assert true
  end

  def test_fail_again
    assert false
  end

end
