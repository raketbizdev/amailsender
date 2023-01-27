# How to send thousands of emails using script

**Step 1:** Install the `mail` and `logger` gems by running the command "gem install mail logger" in your terminal.

**Step 2:** Create a new Ruby file and require the `mail`, `logger`, and `csv` libraries at the top of the file using the following code:

```ruby
require 'mail'
require 'logger'
require 'csv'
```

**Step 3:** Create a new class called `EmailSender` and define an initialize method that takes in two parameters, `username` and `password`. Inside the method, initialize instance variables for the username and password, create a new logger, and set the formatter for the logger.

```ruby
class EmailSender
  def initialize(username, password)
    @username = username
    @password = password
    @logger = Logger.new('email.log')
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime}: #{severity} #{progname} -- #{msg}\n"
    end
  end
```

**Step 4:** Define a method called `create_options_array` that takes in four parameters: `address`, `port`, `authentication`, and `enable_starttls_auto`. Inside the method, create a hash with these options and return it.

```ruby
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
```

**Step 5:** Define a method called `send_emails` that takes in one parameter `provider`. Inside the method, use a case statement to determine which email provider is being used. Depending on the provider, call the `create_options_array` method with the appropriate parameters. Then use the Mail library to set the default delivery method to SMTP and the options that were just created.

**Step 6:** Use a begin-rescue block to iterate through a CSV file called `emails.csv` and send an email to each recipient. Use the `to`, `from`, `subject`, and `body` methods to set the appropriate information for each email. Log any errors that occur.

**Step 7:** At the end of the file, create a new instance of the `EmailSender` class and call the `send_emails` method, passing in the desired email provider.

```ruby
email_sender = EmailSender.new("your@email.com", "yourSecurePassword")
email_sender.send_emails("office365")
```

**Step 8:** Run the file in the terminal using the command "ruby emailsender.rb"

Note: You need to have a CSV file named `emails.csv` in the same directory of your ruby file with at least 3 columns named `email`,`subject`,`body` and their respective values in it.
