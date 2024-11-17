require_relative 'base_entity' 
require 'set'
class Agent < BaseEntity
  def self.type
    "Agent"
  end
  def self.upload_endpoint
    "Agents"
  end

  def self.build_sparql_query(data)
      # Combine parts into a SPARQL query
      <<-SPARQL
        PREFIX foaf: <http://xmlns.com/foaf/0.1/>
        PREFIX owl: <http://www.w3.org/2002/07/owl#>

        SELECT DISTINCT ?agent ?agentType ?name ?email ?homepage (GROUP_CONCAT(DISTINCT ?_sameAs; separator="\\n") AS ?sameAs)
        WHERE {
          ?agent a ?rdfType; foaf:name ?name.
          VALUES ?rdfType { foaf:Person foaf:Organization }
          OPTIONAL { ?agent owl:sameAs ?_sameAs }
            FILTER NOT EXISTS {
            ?agent a foaf:Person, foaf:Organization.
          }
          BIND(IF(?rdfType = foaf:Person, "person", "organization") AS ?agentType)
          BIND(IF(STRSTARTS(STR(?agent), "mailto:"), SUBSTR(STR(?agent), 8), "") AS ?email) # if the agent URI starts with mailto we extract the email
          BIND(IF(?rdfType = foaf:Organization, ?agent, "") AS ?homepage) # if it's an Organization we store the URI as homepage

        }
        GROUP BY ?agent ?agentType ?name ?email ?homepage LIMIT 50
      SPARQL
  end

  def parse_identifier(uri, schemaAgency)
    identifier = {"schemaAgency" => schemaAgency}
    identifier["notation"] = uri.split("/").last
    identifier["creator"] = "admin"
    identifier
  end
  
  def extract_identifiers
    uris = [@agent]
    uris += @sameAs.split() if @sameAs

    @identifiers = []
    uris.to_set.each do |uri|
      case URI::parse(URI::DEFAULT_PARSER.escape(uri)).host
      when "orcid.org"
        @identifiers << parse_identifier(uri, "ORCID")
      when "ror.org"
        @identifiers << parse_identifier(uri, "ROR")
      end

    end
    @identifiers
  end
end
