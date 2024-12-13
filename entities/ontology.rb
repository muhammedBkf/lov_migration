require_relative 'base_entity' 
class Ontology < BaseEntity
  def self.type
    "Ontology"
  end
  def self.upload_endpoint
    "ontologies"
  end

  def self.fetch_portal_all(portalUrl)
    url = URI("#{portalUrl}/ontologies")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  end
end