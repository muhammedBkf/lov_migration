require_relative 'base_entity' 
class Ontology < BaseEntity
  def self.type
    "Ontology"
  end
  def self.upload_endpoint
    "ontologies"
  end
end