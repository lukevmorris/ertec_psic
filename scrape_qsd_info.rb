require 'rubygems'
require 'mechanize'
require 'csv'
require 'set'
require_relative 'zip_codes'

class Harvester
  HOME_PAGE = "http://www.owp.csus.edu/qsd-lookup.php"
  STARTING_ROW = %w(
    Email Last First Company Address City State Zip CertType CertNo Expiry Status
  )

  def initialize(file)
    @all_emails = Set.new
    @csv = CSV.open(file, "a")
    @csv << STARTING_ROW
  end

  def extract_data_from_zips
    agent = Mechanize.new
    agent.get(HOME_PAGE)

    ZipCodes.from_file.each do |zip|
      page = ZipPage.for_zip(zip, agent)
      page.each_data_row do |row|
        @csv.puts(row) if @all_emails.add?(row.email)
      end
      puts zip_code
    end
  end

private
  def process_for_zip(html)
    data_for(html).map do |row|
      email = row[0]
      @csv.puts(row) if @all_emails.add?(email)
    end
  end

  def data_for(html)
    html.css('').map{|entry| process_entry(entry)}
  end

  def get_zip_page(agent, zip)
    info_form = agent.page.forms.first
    info_form.zip_code = zip
    info_form.miles = 50
    info_form.submit
    Nokogiri::HTML.parse(agent.page.body)
  end

  class ZipPage
    def self.for_zip(zip, agent)
      info_form = agent.page.forms.first
      info_form.zip_code = zip
      info_form.miles = 50
      info_form.submit
      html = Nokogiri::HTML.parse(page.body)
      self.new(html)
    end

    def initialize(html)
      @html_rows = html.css(".tropub, .tropubhold")
    end

    def each_data_row
      data_columns = [emails, full_names, addresses, cert_types, cert_numbers, expirys, statuses]
      data_rows = data_columns.transpose.map(&:flatten)
      data_rows.each
    end

    def emails
      @emails ||= @html_rows.css("td:nth-child(2) a:first").map do |node|
        node.text.downcase
      end
    end

    def addresses
      @addresses ||= @html_rows.css("td:nth-child(2) a:last").map do |node|
        # [full, addr, city, state, zip]
        /q=(.*), (.*) (.*)  (.*)/.match(node["href"])[1..-1]
      end
    end

    def cert_types
      @cert_types ||= @html_rows.css("td:nth-child(3)").map(&:text)
    end

    def cert_numbers
      @cert_numbers ||= @html_rows.css("td:nth-child(4)").map(&:text)
    end

    def expirys
      @expirys ||= @html_rows.css("td:nth-child(5)").map(&:text)
    end

    def statuses
      @statuses ||= @html_rows.css("td:last").map(&:text)
    end

    def full_names
      @full_names ||= @html_rows.css("td:first").map do |node|
        node.text.split(", ")
      end
    end
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
