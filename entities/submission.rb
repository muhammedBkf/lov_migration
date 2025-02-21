require_relative 'base_entity' 
require 'net/http'

class Submission < BaseEntity
  def initialize(data)
    super(data)
    get_agents_id
  end

  def self.type
    "Submission"
  end
  def self.upload_endpoint
    "submissions"
  end
  
  def pull_submission
    # Get the basename (filename without path) from the remote URI
    remote_filename = File.basename(URI.parse(@pullLocationn).path)
  
    # Construct the local file path with the remote filename
    file_path = "./tmp/#{remote_filename}"
  
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

    @uploadFilePath = UploadIO.new(File.open(file_path), 'text/n3', File.basename(file_path))
  end  
def load_default_values(data)
    if data
      data.each do |key, property|
      instance_variable_set("@#{key}", property)
      end
    end
    instance_variable_set("@ontology", @acronym.upcase)
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