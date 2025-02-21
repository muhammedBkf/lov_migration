require 'csv'
require 'net/http'
require 'uri'

# Function to send DELETE request
def delete_ontology(prefix)
  url = URI("https://data.lovportal.lirmm.fr/ontologies/#{prefix}")
  request = Net::HTTP::Delete.new(url)
  response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
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