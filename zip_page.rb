class ZipPage
  User = Struct.new(
    :email, :last_name, :first_name, :company, :address, :city,
    :state, :zip, :cert_type, :cert_number, :expiry, :status
  )

  def self.for_zip(zip, agent)
    info_form = agent.page.forms.first
    info_form.zip_code = zip
    info_form.miles = 50
    info_form.submit
    html = Nokogiri::HTML.parse(agent.page.body)
    self.new(html.css(".tropub, .tropubhold"))
  end

  def initialize(html_rows)
    @html_rows = html_rows
  end

  def each_user(&block)
    data_columns = [emails, full_names, companies, addresses, cert_types, cert_numbers, expirys, statuses]
    data_columns.transpose.map do |user_data|
      yield User.new(*user_data.flatten)
    end
  end

  def emails # email
    @html_rows.css("td:nth-child(2) a:first").map {|node| node.text.downcase }
  end

  def full_names # [last, first]
    @html_rows.css("td:first").map {|node| node.text.split(", ") }
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
