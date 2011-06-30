require "rubygems"
require "bundler/setup"

require "yaml"

require "pony"
require "ValidateEmail"

def error(message)
  puts message
end

def log(message)
  puts message
end

if not File.exist?('config.yml')
  error "please create a configuration file named config.yml, see config.example.yml for an example"
  exit
end
if not File.exist?('mail.txt')
  error "please create a file named mail.txt which holds the mail text (first line subject, followed by a blank line, followed by the mail body)"
  exit
end
if not File.exist?('recipients.txt')
  error "please create a file named recipients.txt which holds the recipients email addresses (one line per address)"
  exit
end

config = YAML.load_file('config.yml')

mail = File.open('mail.txt') {|f| f.readlines }
subject = mail.shift.strip
mail.shift # skip second line
body = mail.join

recipients = File.open('recipients.txt') {|f| f.readlines.map{|e| e.strip}}

log "got #{recipients.size} recipients from recipients.txt"
# validate mail adresses
valid_recipients = Array.new
recipients.each_with_index do |email, index|
  invalid = false
  if email.strip.empty?
    #error "got empty email in line #{index+1}"
    invalid = true
  end
  if not ValidateEmail.validate(email)
    #error "invalid email address in line #{index+1}: #{email}"
    invalid = true
  end
  valid_recipients << email unless invalid
end
log "#{valid_recipients.size} after removing invalid ones"

Pony.options = {
  :from => "#{config['from_name']} <#{config['from_email']}>",
  :via => :smtp,
  :charset => 'UTF-8',
  :via_options => {
    :address        => config['server'],
    :port           => config['port'],
  # :user_name      => config['username'],
  # :password       => config['password'],
    :enable_starttls_auto => false,
  #  :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
  }
}

max_recipients_per_mail = 20

recs = valid_recipients.shift(max_recipients_per_mail)

begin
  while not recs.empty? do
    log "sending mail to #{recs.inspect}..."
    begin
      Pony.mail(:to => '', :bcc => recs, :subject => subject, :body => body)
    rescue Timeout::Error => e
      log "got timeout"
      File.open('timeout_addresses.txt', 'a'){|f| f.write recs.join("\n")+"\n"}
    end
    recs = valid_recipients.shift(max_recipients_per_mail)
  end
rescue => e
  error "got error #{e.message}"
  File.open("addresses-left-#{Time.now.to_i}.txt", 'w'){|f| f.write valid_recipients.join("\n")}
end

