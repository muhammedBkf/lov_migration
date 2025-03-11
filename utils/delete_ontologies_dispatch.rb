require 'csv'
require 'net/http'
require 'uri'
require 'dotenv'
Dotenv.load

LOVPORTAL_ENDPOINT = ENV['LOVPORTAL_ENDPOINT']

# Function to send DELETE request
def delete_ontology(prefix)
  url = URI("#{LOVPORTAL_ENDPOINT}/ontologies/#{prefix}")

  request = Net::HTTP::Delete.new(url)
  response = Net::HTTP.start(url.hostname, url.port) do |http|
    http.request(request)
  end

  if response.code == "204"
    puts "Successfully deleted ontology with prefix: #{prefix}"
  else
    puts "Failed to delete ontology with prefix: #{prefix}. Status code: #{response.code}"
  end
end

# Read the CSV file
CSV.foreach('LOV_vocabularies_dispatch.csv', headers: true) do |row|
  prefix = row['prefix'].upcase  # Make the prefix uppercase
  delete_ontology(prefix)
end