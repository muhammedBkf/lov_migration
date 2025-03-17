require_relative 'base_entity' 
require 'net/http'
require 'fileutils'
class Submission < BaseEntity
  def initialize(data)
    super(data)
    map_language
    get_agents_id
  end

  def self.type
    "Submission"
  end
  def self.upload_endpoint
    "submissions"
  end
  
  def pull_submission

    # Create the ./tmp directory if it doesn't exist
    folder_path = "./tmp/#{@acronym}"
    FileUtils.mkdir_p(folder_path)
  
    # Get the basename (filename without path) from the remote URI
    remote_filename = File.basename(URI.parse(@pullLocationn).path)
  
    # Construct the local file path with the remote filename
    file_path = "#{folder_path}/#{remote_filename}"
    # Check if the file already exists
    unless File.exist?(file_path)  
    uri = URI.parse(@pullLocationn)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      
      http.request(request) do |response|
        File.open(file_path, 'wb') do |file|
          response.read_body do |chunk|
            file.write(chunk)
end
          end
        end
      end
    end

    @uploadFilePath = UploadIO.new(File.open(file_path), 'text/n3', File.basename(file_path))
  end  

  def reset_agents
    # Parse the LOVPORTAL_ENDPOINT URL
    url = URI.parse(LOVPORTAL_ENDPOINT)
    
    # Construct the PATCH request to reset agents
    request = Net::HTTP::Patch.new("#{url}/ontologies/#{@acronym.upcase}/latest_submission")
    request['Authorization'] = "apikey token=#{ENV['API_KEY']}"
    request['content-type'] = 'multipart/form-data'
    
    # Define the form data to reset agents
    form_data = [
      ["hasContributor", "[]"],
      ["hasCreator", "[]"],
      ["hasPublisher", "[]"],
      ["curatedBy", "[]"]
    ]
    request.set_form(form_data, 'multipart/form-data')
  
    # Execute the request
    response = Net::HTTP.start(url.hostname, url.port) do |http|
      http.request(request)
    end
  
    # Return the response
    response
  end
  # This is used to upload an entity (Agent, Ontology, Submission)
  def update
    url = URI.parse(LOVPORTAL_ENDPOINT)
    
    reset_agents

    request = Net::HTTP::Patch.new("#{url}/ontologies/#{@acronym.upcase}/latest_submission")
    request['Authorization'] = "Authorization: apikey token=#{ENV['API_KEY']}"
    request['content-type'] = 'multipart/form-data'
  
    # Set form data
    form_data = to_multipart_form_data
    request.set_form form_data, 'multipart/form-data'

    # Execute the request
    response = Net::HTTP.start(url.hostname, url.port) do |http|
      http.request(request)
    end
  end

    # Helper function to fetch the latest submission version from LOVPORTAL_ENDPOINT
    def fetch_latest_submission_version
      # Construct the URL for the latest submission

      url = URI.parse("#{LOVPORTAL_ENDPOINT}/ontologies/#{@acronym.upcase}/latest_submission")
      
      # Send a GET request to the endpoint
      response = Net::HTTP.get_response(url)

      if response.is_a?(Net::HTTPSuccess)
        # Parse the response body to extract the version
        latest_submission = JSON.parse(response.body)
        latest_submission_version = latest_submission['version']
        return latest_submission_version
      else
        raise "Failed to fetch latest submission version for #{acronym}. Response code: #{response.code}"
      end
    end

def load_default_values(data)
    if data
      data.each do |key, property|
      instance_variable_set("@#{key}", property)
      end
    end
    instance_variable_set("@ontology", @acronym.upcase)
  end
  # Language URI mapping
  def map_language
    if instance_variable_defined?("@naturalLanguage")
      puts @naturalLanguage
     @naturalLanguage = map_multiple_language_uris(@naturalLanguage)
    end
  end
# Map multiple language URIs separated by "||"
def map_multiple_language_uris(language_uris)
  # Split the string into individual URIs
  language_uris.split("||").map do |uri|
    map_language_uri(uri.strip) # Strip any whitespace and map each URI
  end
end

def map_language_uri(language_uri)
  language_mapping = {
    "http://id.loc.gov/vocabulary/iso639-2/eng" => "http://lexvo.org/id/iso639-1/en",  # English
    "http://id.loc.gov/vocabulary/iso639-2/fra" => "http://lexvo.org/id/iso639-1/fr",  # French
    "http://id.loc.gov/vocabulary/iso639-2/ita" => "http://lexvo.org/id/iso639-1/it",  # Italian
    "http://id.loc.gov/vocabulary/iso639-2/spa" => "http://lexvo.org/id/iso639-1/es",  # Spanish
    "http://id.loc.gov/vocabulary/iso639-2/por" => "http://lexvo.org/id/iso639-1/pt",  # Portuguese
    "http://id.loc.gov/vocabulary/iso639-2/nld" => "http://lexvo.org/id/iso639-1/nl",  # Dutch
    "http://id.loc.gov/vocabulary/iso639-2/deu" => "http://lexvo.org/id/iso639-1/de",  # German
    "http://id.loc.gov/vocabulary/iso639-2/rus" => "http://lexvo.org/id/iso639-1/ru",  # Russian
    "http://id.loc.gov/vocabulary/iso639-2/swe" => "http://lexvo.org/id/iso639-1/sv",  # Swedish
    "http://id.loc.gov/vocabulary/iso639-2/jpn" => "http://lexvo.org/id/iso639-1/ja",  # Japanese
    "http://id.loc.gov/vocabulary/iso639-2/ron" => "http://lexvo.org/id/iso639-1/ro",  # Romanian
    "http://id.loc.gov/vocabulary/iso639-2/pol" => "http://lexvo.org/id/iso639-1/pl",  # Polish
    "http://id.loc.gov/vocabulary/iso639-2/afr" => "http://lexvo.org/id/iso639-1/af",  # Afrikaans
    "http://id.loc.gov/vocabulary/iso639-2/zho" => "http://lexvo.org/id/iso639-1/zh",  # Chinese
    "http://id.loc.gov/vocabulary/iso639-2/ces" => "http://lexvo.org/id/iso639-1/cs",  # Czech
    "http://id.loc.gov/vocabulary/iso639-2/fin" => "http://lexvo.org/id/iso639-1/fi",  # Finnish
    "http://id.loc.gov/vocabulary/iso639-2/ara" => "http://lexvo.org/id/iso639-1/ar",  # Arabic
    "http://id.loc.gov/vocabulary/iso639-2/cat" => "http://lexvo.org/id/iso639-1/ca",  # Catalan
    "http://id.loc.gov/vocabulary/iso639-2/ell" => "http://lexvo.org/id/iso639-1/el",  # Greek
    "http://id.loc.gov/vocabulary/iso639-2/nor" => "http://lexvo.org/id/iso639-1/no",  # Norwegian
    "http://id.loc.gov/vocabulary/iso639-2/tur" => "http://lexvo.org/id/iso639-1/tr",  # Turkish
    "http://id.loc.gov/vocabulary/iso639-2/bul" => "http://lexvo.org/id/iso639-1/bg",  # Bulgarian
    "http://id.loc.gov/vocabulary/iso639-2/hun" => "http://lexvo.org/id/iso639-1/hu",  # Hungarian
    "http://id.loc.gov/vocabulary/iso639-2/lav" => "http://lexvo.org/id/iso639-1/lv",  # Latvian
    "http://id.loc.gov/vocabulary/iso639-2/slk" => "http://lexvo.org/id/iso639-1/sk",  # Slovak
    "http://id.loc.gov/vocabulary/iso639-2/eus" => "http://lexvo.org/id/iso639-1/eu",  # Basque
    "http://id.loc.gov/vocabulary/iso639-2/bel" => "http://lexvo.org/id/iso639-1/be",  # Belarusian
    "http://id.loc.gov/vocabulary/iso639-2/ben" => "http://lexvo.org/id/iso639-1/bn",  # Bengali
    "http://id.loc.gov/vocabulary/iso639-2/hrv" => "http://lexvo.org/id/iso639-1/hr",  # Croatian
    "http://id.loc.gov/vocabulary/iso639-2/dan" => "http://lexvo.org/id/iso639-1/da",  # Danish
    "http://id.loc.gov/vocabulary/iso639-2/glg" => "http://lexvo.org/id/iso639-1/gl",  # Galician
    "http://id.loc.gov/vocabulary/iso639-2/isl" => "http://lexvo.org/id/iso639-1/is",  # Icelandic
    "http://id.loc.gov/vocabulary/iso639-2/gle" => "http://lexvo.org/id/iso639-1/ga",  # Irish
    "http://id.loc.gov/vocabulary/iso639-2/kau" => "http://lexvo.org/id/iso639-1/kr",  # Kanuri
    "http://id.loc.gov/vocabulary/iso639-2/kor" => "http://lexvo.org/id/iso639-1/ko",  # Korean
    "http://id.loc.gov/vocabulary/iso639-2/lit" => "http://lexvo.org/id/iso639-1/lt",  # Lithuanian
    "http://id.loc.gov/vocabulary/iso639-2/srp" => "http://lexvo.org/id/iso639-1/sr",  # Serbian
    "http://id.loc.gov/vocabulary/iso639-2/slv" => "http://lexvo.org/id/iso639-1/sl",  # Slovenian
    "http://id.loc.gov/vocabulary/iso639-2/vie" => "http://lexvo.org/id/iso639-1/vi",  # Vietnamese
    "http://id.loc.gov/vocabulary/iso639-2/sqi" => "http://lexvo.org/id/iso639-1/sq",  # Albanian
    "http://id.loc.gov/vocabulary/iso639-2/hye" => "http://lexvo.org/id/iso639-1/hy",  # Armenian
    "http://id.loc.gov/vocabulary/iso639-2/epo" => "http://lexvo.org/id/iso639-1/eo",  # Esperanto
    "http://id.loc.gov/vocabulary/iso639-2/est" => "http://lexvo.org/id/iso639-1/et",  # Estonian
    "http://id.loc.gov/vocabulary/iso639-2/ewe" => "http://lexvo.org/id/iso639-1/ee",  # Ewe
    "http://id.loc.gov/vocabulary/iso639-2/kat" => "http://lexvo.org/id/iso639-1/ka",  # Georgian
    "http://id.loc.gov/vocabulary/iso639-2/heb" => "http://lexvo.org/id/iso639-1/he",  # Hebrew
    "http://id.loc.gov/vocabulary/iso639-2/hin" => "http://lexvo.org/id/iso639-1/hi",  # Hindi
    "http://id.loc.gov/vocabulary/iso639-2/lat" => "http://lexvo.org/id/iso639-1/la",  # Latin
    "http://id.loc.gov/vocabulary/iso639-2/lux" => "http://lexvo.org/id/iso639-1/lb",  # Luxembourgish
    "http://id.loc.gov/vocabulary/iso639-2/mkd" => "http://lexvo.org/id/iso639-1/mk",  # Macedonian
    "http://id.loc.gov/vocabulary/iso639-2/msa" => "http://lexvo.org/id/iso639-1/ms",  # Malay
    "http://id.loc.gov/vocabulary/iso639-2/mlt" => "http://lexvo.org/id/iso639-1/mt",  # Maltese
    "http://id.loc.gov/vocabulary/iso639-2/fas" => "http://lexvo.org/id/iso639-1/fa",  # Persian
    "http://id.loc.gov/vocabulary/iso639-2/ukr" => "http://lexvo.org/id/iso639-1/uk"   # Ukrainian
  }
  language_mapping[language_uri] || language_uri
end
  def get_agents_id
    AGENTS_ATTRIBUTES.each do |attribute|
      next unless instance_variable_defined?("@#{attribute}") && instance_variable_get("@#{attribute}").is_a?(Array)

      # Get the current value of the instance variable and update it
      updated_agents = instance_variable_get("@#{attribute}").map do |agent_name|
        # Call the method to get the agent ID
        agent_id = Agent.get_agent_id_by_name(agent_name)
          
        # If agent_id is nil, log the error to error_logs.txt
        if agent_id.nil?
          File.open("error_logs.txt", "a") do |file|
            file.puts "Error: Cannot find agent with name '#{agent_name}'"
          end
          next nil # Skip this agent
        end
      
        agent_id # Return the agent ID if it's not nil
      end.compact

      # Set the updated value back to the instance variable
      instance_variable_set("@#{attribute}", updated_agents)
    end
  end  
end