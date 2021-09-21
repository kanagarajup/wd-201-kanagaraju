def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

# ..
# ..
# FILL YOUR CODE HERE

def parse_dns(dns_raw)
  domain_record = Hash.new
  dns_raw.each { |record|
    record_split = record.split(",")
    if record_split[0].eql? ("A")
      domain_record[record_split[1].strip] = { type: record_split[0].strip, target: record_split[2].strip }
    elsif record_split[0].eql? ("CNAME")
      domain_record[record_split[1].strip] = { type: record_split[0].strip, target: record_split[2].strip }
    end
  }
  domain_record
end

def resolve(dns_records, lookup_chain, domain)
  record = dns_records[domain]
  if (!record)
    lookup_chain = []
    lookup_chain << "Error: Record not found for " + domain
    return lookup_chain
  elsif record[:type] == "CNAME"
    lookup_chain << record[:target]
    resolve(dns_records, lookup_chain, record[:target])
  elsif record[:type] == "A"
    lookup_chain << record[:target]
    return lookup_chain
  else
    lookup_chain << "Invalid record type for " + domain
    return lookup_chain
  end
end

# ..
# ..

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
