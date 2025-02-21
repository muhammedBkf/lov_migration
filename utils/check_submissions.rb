require 'csv'
require 'net/http'
require 'uri'
require 'json'


LOV_ENDPOINT = "https://lov.linkeddata.es/dataset/lov/api/v2/vocabulary/info?vocab={vocab}"
LOVPORTAL_ENDPOINT = "https://data.testportal.lirmm.fr"


  # Function to read acronyms from the CSV file
  def read_acronyms(csv_file)
    acronyms = []
    CSV.foreach(csv_file, headers: true) do |row|
      acronyms << row['prefix']
    end
    acronyms
  end
  
  # Function to send a request to a given URL
  def send_request(url, vocab)
    uri = URI.parse(url.gsub('{vocab}', vocab))
    response = Net::HTTP.get_response(uri)
    response
  end
  
  def get_submissions_count(url, vocab, data=nil)
      begin
        if !data.nil?
          # For LOV API: Count versions with 'fileURL'
          submissions = data['versions'].select { |v| v.key?('fileURL') }
          submissions.size
        elsif url.include?(LOVPORTAL_ENDPOINT)
          response = send_request(url, vocab)
  
          # Raise an error for bad status codes
          raise "HTTP error: #{response.code}" unless response.is_a?(Net::HTTPSuccess)
    
          data = JSON.parse(response.body)
  
          # For LIRMM API: Directly get the length of the submissions array
          data.size
        else
          raise "Unsupported URL format"
        end
      rescue StandardError => e
        puts "Error fetching data from #{url}: #{e}"
        nil
      end
  end
    
  def check_submissions_number(acronym, lov_data)
    lovPortal_url = "#{LOVPORTAL_ENDPOINT}/ontologies/{vocab}/submissions"
    count1 = get_submissions_count(lovPortal_url, acronym, lov_data)
    count2 = get_submissions_count(lovPortal_url, acronym.upcase)
    if !count1.nil? && !count2.nil?
      "#{count1 == count2} (#{count1})"
    else
      false
    end
  end

  def get_agents_count(url, vocab, data=nil)
    begin
      if !data.nil?
        # Extract contributorIds, creatorIds, and publisherIds from the data
        contributors = data['contributorIds'] || []
        creators = data['creatorIds'] || []
        publishers = data['publisherIds'] || []
  
        # Combine all agent IDs and remove duplicates
        agents = (contributors + creators + publishers).uniq
        agents.size
      elsif url.include?(LOVPORTAL_ENDPOINT)
        response = send_request(url, vocab)
  
        # Raise an error for bad status codes
        raise "HTTP error: #{response.code}" unless response.is_a?(Net::HTTPSuccess)
  
        data = JSON.parse(response.body)
  
        # For LIRMM API: Directly get the length of the agents array
        data.size
      else
        raise "Unsupported URL format"
      end
    rescue StandardError => e
      puts "Error fetching data from #{url}: #{e}"
      nil
    end
  end
  
  def check_agents_number(acronym, lov_data)
    lovPortal_url = "#{LOVPORTAL_ENDPOINT}/ontologies/{vocab}/agents"
    count1 = get_agents_count(lovPortal_url, acronym, lov_data)
    count2 = get_agents_count(lovPortal_url, acronym.upcase)
    if !count1.nil? && !count2.nil?
      "#{count1 == count2} (#{count1})"
    else
      false
    end
  end

  def verify_response_2(response)
    # Implement your verification logic here
    response.body.include?('example') # Example condition
  end
  
  # Function to write results to a new CSV file
  def write_results(csv_file, results)
    CSV.open(csv_file, 'w', write_headers: true, headers: ['acronym', 'submissions number', 'agents number']) do |csv|
      results.each do |result|
        csv << result
      end
    end
  end

  # Main function to process acronyms and verify responses
  def process_acronyms(input_csv, output_csv)
    acronyms = read_acronyms(input_csv)
    results = []
  
    acronyms.each do |acronym|
      url1 = "https://lov.linkeddata.es/dataset/lov/vocabs/#{acronym}"
      url2 = "https://data.testportal.lirmm.fr/ontologies/#{acronym}"
      puts <<~TEXT
    [X] Checking for acronym: #{acronym}
        - #{url1}
        - #{url2}
  TEXT
      response = send_request(LOV_ENDPOINT, acronym)
      lov_data = JSON.parse(response.body)
      #response2 = send_request(url2, acronym)
  
      result1 = check_submissions_number(acronym, lov_data)
      result2 = check_agents_number(acronym, lov_data)
      results << [acronym, result1, result2]
    end
  
    write_results(output_csv, results)
  end


input_csv = 'LOV_vocabularies_dispatch.csv'
output_csv = 'results.csv'
process_acronyms(input_csv, output_csv)




# # Example usage
# acronym = "airo"
# result = check_submissions_match(acronym)
# puts "Submissions match for #{acronym}: #{result}"