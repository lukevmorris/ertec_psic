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
