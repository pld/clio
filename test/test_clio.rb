require 'test/unit'
require 'clio'

class ClioTest < Test::Unit::TestCase
  def test_set_referer
    e = Clio.new('ref')
    assert_equal 'ref', e.referer
  end

  # requires internet connectivity
  def test_get_search_response
    e = Clio.new('example.com')
    assert_equal false, e.search('nano fibers').empty?
  end

  # requires internet connectivity
  def test_get_num_search_response
    e = Clio.new('example.com', 10)
    assert_equal 10, e.search('nano fibers').length
  end

  # requires internet connectivity
  def test_work_with_fewer_than_limit_returned
    e = Clio.new('example.com')
    # if 'helicoid' returns >= 100 results this test is trivial
    assert_equal false, e.search('helicoid').empty?
  end

  def test_result_format
    e = Clio.new('example.com')
    results = e.search('nano fibers')
    results.each do |result|
      assert_equal result.title.class, String
      assert_equal result.url.class, String
      assert result.url.include? 'http://cliobeta.columbia.edu'
      assert [NilClass, String].include?(result.subtitle.class)
      assert [NilClass, String].include?(result.authors.class)
      assert_equal result.published.class, String
      assert [NilClass, Hash].include?(result.online.class)
      if result.online.class == Hash
        result.online.each do |key, value|
          assert_equal key.class, String
          assert_equal value.class, String
        end
      end
    end
  end

  # TODO test this 
  def test_return_nil_on_error
    e = Clio.new('example.com', 10)
  end

  # requires internet connectivity
  def test_return_empty_if_not_results
    e = Clio.new('example.com')
    # if 'Ambiogenesis568' returns results this test is trivial
    assert_equal true, e.search('Ambiogenesis568').empty?
  end
end

