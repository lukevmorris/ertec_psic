require 'rubygems'
require 'mechanize'

class ZipCodes
  ZIP_STORE = "zip_codes.txt"

  def self.from_file
    File.readlines(ZIP_STORE).map(&:chomp)
  end

  def self.refresh_store
    agent = Mechanize.new
    agent.get("http://www.zipcodestogo.com/California/")
    html = Nokogiri::HTML.parse(agent.page.body)
    zip_codes = html.css('td[align="center"] a').children.map(&:text)
    File.open(ZIP_STORE, 'w') { |file| file.puts(zip_codes) }
  end
end
