require 'rubygems'

require 'cgi'
require 'nokogiri'
require 'open-uri'


ClioResult = Struct.new :title, :url, :subtitle, :authors, :published, :online


class Clio 
  # API for Columbia Library CLIO Beta search engine
  # 
  # Example:
  #   >> Clio.new('[Referer]').search('nano fibers')
  #   => [ #<ClioResult:...>, ... ]
  #
  # Arguments:
  #   referer: (String)
  #   num_results: (Integer+)

  ROOT_URL = 'http://cliobeta.columbia.edu'
  API_PATH = "#{ROOT_URL}/catalog?&"

  attr_accessor :referer, :num_results

  def initialize(referer='', num_results=100)
    @referer = referer
    @num_results = num_results
  end
  
  def search(query)
    params = "per_page=#{@num_results}&q=#{CGI.escape(query)}"
    response = open(API_PATH + params, { 'Referer' => @referer })
    return nil if response.class.superclass == Net::HTTPServerError
    doc = Nokogiri::HTML(response)
    # check that results were returned
    # fetch number of results so we slice properly
    num_returned = doc.css('.pageEntriesInfo b:first')[0]
    return [] if num_returned == nil
    num_returned = num_returned.content.split(/(\d+)/)[-1].to_i
    css_types = {
      :title => 0,
      :other => 1
    }
    css_attrs = [
      '.title a',
      '.details',
    ]
    tag_sets = doc.css(css_attrs.join(', ')
        ).each_slice(num_returned).map { |el| el }.transpose
    tag_sets.map do |tag_set|
      # build hash from details
      details = {}
      tag_set[css_types[:other]].css('.row').each do |row|
        label = row.css('.label')[0].content.downcase
        entries = row.css('.entry')
        # online labels have >= 1 links to extract
        details[label] = (label == 'online') ? entries.inject({}) do |h, entry|
          link = entry.css('a')[0]
          h[link.content] = link['href']
          h
        end : entries[0].content
      end

      ClioResult.new(
        tag_set[css_types[:title]].content,
        ROOT_URL + tag_set[css_types[:title]]['href'],
        details['subtitle'],
        details['author'],
        details['published'],
        details['online']
      )
    end
  end
end
