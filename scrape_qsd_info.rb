require 'rubygems'
require 'mechanize'
require 'csv'
require 'set'
require_relative 'zip_codes'

class Harvester
  attr_accessor :csv, :all_emails, :queue, :mutex

  def initialize(file)
    self.csv = CSV.open(file, 'a')
    self.all_emails = Set.new
    # self.queue = Queue.new
    # self.mutex = Mutex.new
  end

  def process_for_zips
    csv << %w( Email Last First Company Address City State Zip CertType CertNo Expiry Status )
    # ZipCodes.from_file.each{|zip| queue << zip}

    # threads = []
    # 6.times do
    #   threads << Thread.new do
    agent = Mechanize.new
    agent.get('http://www.owp.csus.edu/qsd-lookup.php')
    # while (new_zip = queue.pop(true) rescue nil) do
    ZipCodes.from_file.each do |zip_code|
      process_for_zip(agent, zip_code)
    end
    # end
    #   end
    # end
    # threads.map(&:join)
  end

private
  def process_for_zip(agent, zip)
    data = data_for(agent, zip)
    mutex.synchronize do
      data.map do |row|
        unless all_emails.include?(row[0])
          all_emails << row[0]
          csv << row
        end
      end
    end
    puts zip
  end

  def data_for(agent, zip)
    html = retrieve_for_zip(agent, zip)
    all_entries = html.css('.tropub, .tropubhold')
    all_entries.map{|entry| process_entry(entry)}
  end

  def retrieve_for_zip(agent, zip)
    info_form = agent.page.forms.first
    info_form.zip_code = zip
    info_form.miles = 50
    info_form.submit
    Nokogiri::HTML.parse(agent.page.body)
  end

  def process_entry(entry)
    email = email_for(entry)
    addresses = addresses_for(entry)
    company = company_for(entry, addresses)
    fullname = fullname_for(entry)
    type = type_for(entry)
    certno = certno_for(entry)
    expiry = expiry_for(entry)
    status = status_for(entry)
    [email, fullname, company, addresses, type, certno, expiry, status].flatten
  end

  def email_for(entry)
    entry.css('td:nth-child(2)').css('a:first').first.text.downcase
  end

  def addresses_for(entry)
    full = entry.css('td:nth-child(2)').css('a:last').first['href'].match(/\?q=(.*)/)[1].reverse
    zip, rest = full.split('  ',2)
    state, rest = rest.split(' ',2)
    city, addrs = rest.split(' ,',2)
    [addrs, city, state, zip].map(&:reverse)
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

  def fullname_for(entry)
    entry.css('td:first').first.text.split(', ', 2)
  end

  def type_for(entry)
    entry.css('td:nth-child(3)').first.text
  end

  def certno_for(entry)
    entry.css('td:nth-child(4)').first.text
  end

  def expiry_for(entry)
    entry.css('td:nth-child(5)').first.text
  end

  def status_for(entry)
    entry.css('td:last').first.text
  end
end
