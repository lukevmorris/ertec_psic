require 'rubygems'
require 'mechanize'
require 'csv'
require 'set'
require_relative 'zip_codes'
require_relative 'zip_page'

class ZipHarvester
  HOME_PAGE = "http://www.owp.csus.edu/qsd-lookup.php"
  STARTING_ROW = %w(
    Email Last First Company Address City State Zip CertType CertNo Expiry Status
  )

  def initialize(file)
    @all_emails = Set.new
    @csv = CSV.open(file, "a")
    @csv.puts(STARTING_ROW)
  end

  def extract_data_from_zips
    agent = Mechanize.new
    agent.get(HOME_PAGE)

    ZipCodes.each do |zip|
      ZipPage.for_zip(zip, agent).each_user do |user|
        @csv.puts(user) if @all_emails.add?(user.email)
      end
      puts zip
    end
  end

  def company_for(entry, addresses)
    potential_company = entry.css('td:nth-child(2)').first.children[2].text
    if addresses[0].include?(potential_company)
      ""
    else
      potential_company.downcase.split(' ').map { |word|
        word.capitalize unless %( and or the over to a but ).include?(word)
      }.join(' ')
    end
  end
end
