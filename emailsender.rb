require 'mail'
require 'logger'
require 'csv'

class EmailSender

  def initialize(username, password)
    @username = username
    @password = password
    @logger = Logger.new('email.log')
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime}: #{severity} #{progname} -- #{msg}\n"
    end
  end

  def create_options_array(address, port, authentication, enable_starttls_auto)
    options = {
        :address => address,
        :port => port,
        :user_name => @username,
        :password => @password,
        :authentication => authentication,
        :enable_starttls_auto => enable_starttls_auto
    }
    return options
  end

  def send_emails(provider)
    case provider
    when "office365"
        options = create_options_array("smtp.office365.com", 587, :login, true)
    when "gmail"
        options = create_options_array("smtp.gmail.com", 587, "plain", true)
    else
        raise "Invalid email provider"
    end

    Mail.defaults do
      delivery_method :smtp, options
    end
    begin
        CSV.foreach("emails.csv", headers: true) do |row|
            mail = Mail.deliver do
                to row["email"]
                from @username
                subject row["subject"]
                body row["body"]
            end
            @logger.info "Email sent successfully to #{mail.to}"
        end
    rescue Net::SMTPAuthenticationError => e
        @logger.error "SMTP Authentication error occured while sending email #{e.message}"
    rescue Net::SMTPServerBusy => e
        @logger.error "SMTP Server busy error occured while sending email #{e.message}"
    rescue Net::SMTPFatalError => e
        @logger.error "SMTP Fatal error occured while sending email #{e.message}"
    rescue Net::SMTPUnknownError => e
        @logger.error "SMTP Unknown error occured while sending email #{e.message}"
    rescue Net::SMTPError => e
        @logger.error "SMTP Helo error occured while sending email #{e.message}"
    rescue => e
        @logger.error "Error occured while sending email #{e.message}"
    end
  end
end

# Usage
email_sender = EmailSender.new("your@email.com", "yourSecurePassword")
email_sender.send_emails("office365")