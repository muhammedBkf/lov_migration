require_relative 'base_entity' 
require 'net/http'

class Submission < BaseEntity
  def self.type
    "Submission"
  end
  def self.upload_endpoint
    "submissions"
  end
  
  def pull_submission
    file_path = "./tmp/#{@acronym}.n3"
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
        Agent.get_agent_id_by_name(agent_name)
      end

      # Set the updated value back to the instance variable
      instance_variable_set("@#{attribute}", updated_agents)
    end
  end  
end