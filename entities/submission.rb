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

  
end