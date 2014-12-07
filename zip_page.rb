class ZipPage
  User = Struct.new(
    :email, :last_name, :first_name, :company, :address, :city,
    :state, :zip, :cert_type, :cert_number, :expiry, :status
  )

  def self.for_zip(zip, agent)
    info_form = agent.page.forms.first
    info_form.zip_code = zip
    info_form.miles = 50

    print " - Requesting page..."
    request_start = Time.now
    info_form.submit
    request_end = Time.now
    puts "#{request_end - request_start} seconds"

    html = Nokogiri::HTML.parse(agent.page.body)
    self.new(html.css(".tropub, .tropubhold"), zip)
  end

  def initialize(html_rows, zip)
    @html_rows = html_rows
    @zip = zip
  end

  def inspect
    "<< Zip Page for zip code #{@zip} >>"
  end

  def users
    print " - Parsing page..."
    parse_start = Time.now
    data_columns = [emails, full_names, companies, addresses, cert_types, cert_numbers, expirys, statuses]
    parse_end = Time.now
    puts "#{parse_end - parse_start} seconds"

    data_columns.transpose.map do |user_data|
      User.new(*user_data.flatten)
    end
  end

  def emails # email
    @html_rows.css("td:nth-child(2) a:first").map {|node| node.text.downcase }
  end

  def full_names # [last, first]
    @html_rows.css("td:first").map {|node| node.text.split(", ", 2) }
  end

  def companies # company || ""
    potential_companies = @html_rows.css("td:nth-child(2)").map {|node| node.children[2].text }
    potential_companies.zip(address_queries).map do |company, address|
      address[company] ? "" : company
    end
  end

  def addresses # [addr, city, state, zip]
    address_queries.map {|query| /q=(.*), (.*) (.*)  (.*)/.match(query)[1..-1] }
  end

  def cert_types # cert_type
    @html_rows.css("td:nth-child(3)").map(&:text)
  end

  def cert_numbers # cert_number
    @html_rows.css("td:nth-child(4)").map(&:text)
  end

  def expirys # expiry
    @html_rows.css("td:nth-child(5)").map(&:text)
  end

  def statuses # status
    @html_rows.css("td:last").map(&:text)
  end

  def address_queries
    @html_rows.css("td:nth-child(2) a:last").map {|node| node["href"] }
  end
end
