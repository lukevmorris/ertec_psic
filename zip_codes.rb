require 'rubygems'
require 'mechanize'

class ZipCodes
  include Enumerable
  
  ZIP_STORE = "zip_codes.txt"
  ZIP_MASTER = "http://www.zipcodestogo.com/California/"

  def self.each
    File.readlines(ZIP_STORE).each { |zip| yield zip.chomp }
  end

  def self.refresh_store
    page = Mechanize.new.get(ZIP_MASTER)
    html = Nokogiri::HTML.parse(page.body)
    zip_codes = html.css('td[align="center"] a').children.map(&:text)
    File.open(ZIP_STORE, 'w') { |file| file.puts(zip_codes) }
  end
end
