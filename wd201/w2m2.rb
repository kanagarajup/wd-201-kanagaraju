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
$domain_A = Hash.new
$domain_Cname = Hash.new

def parse_dns(dns_raw)
  dns_raw.each { |it|
    l = it.split(",")
    if ((l[0].to_s).eql? ("A"))
      $domain_A[l[1].strip] = l[2].strip
    elsif ((l[0].to_s).eql? ("CNAME"))
      $domain_Cname[l[1].strip] = l[2].strip
    end
  }
  $domain_Cname
end

def resolve(dns_records, lookup_chain, domain)
  lookup_find = ""
  while true
    if $domain_A.has_key?(domain)
      lookup_chain << $domain_A[domain]
      break
    else
      domain_find = "N"
      if $domain_Cname.has_key?(domain)
        domain_find = $domain_Cname[domain]
      end
      domain1 = domain
      domain = domain_find
      lookup_chain << domain
      if (domain_find.eql? ("N"))
        lookup_find = "Error: record not found for " + domain1
        lookup_chain.clear()
        lookup_chain << lookup_find
        break
      else
        resolve(dns_records, lookup_chain, domain_find)
        break
      end
    end
  end
  lookup_chain
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
