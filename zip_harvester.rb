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

  def harvest!
    agent = Mechanize.new
    agent.get(HOME_PAGE)
    ZipCodes.each {|zip| record_data_for_zip(zip, agent) }
  end

  def record_data_for_zip(zip, agent)
    ZipPage.for_zip(zip, agent).users.each do |user|
      @csv.puts(user) if @all_emails.add?(user.email)
    end
    puts zip
  end
end
