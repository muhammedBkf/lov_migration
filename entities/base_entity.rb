
require_relative '../config/mapping'
require 'open-uri'
require 'net/http'
require 'json'

class BaseEntity
  # Initialize attributes based on the given hash
  def initialize(data)
   data.each do |key, properties|
     self.class.attr_accessor key.to_sym

     # Set the attribute's value based on the "value" key in the properties hash
     instance_variable_set("@#{key}", properties["value"])
   end
  end
  
  def self.type
    "Generic"
  end
  
  def self.upload_endpoint
    "Generic"
  end
def self.set_target_portal(value)
    @@targetPortal = value
  end
  def self.targetPortal
    @@targetPortal
  end

  def self.target_portal_dispatch_vocabs
  csv_file = 'LOV_vocabularies_dispatch.csv'
    vocabs = []
      CSV.foreach(csv_file, headers: true) do |row|
        if  row['destination']
          vocabs << row["prefix"] if row['destination'].include?(@@targetPortal)
        end
      end
    vocabs
  end
  
  def self.fetch_all(vocabsAcronyms=nil)
    entities = []
    entity_type = self.type
    query = build_sparql_query(DATA_MAPPING[entity_type], vocabsAcronyms)
    query = build_sparql_query(DATA_MAPPING[entity_type])
    sparql_query(query).map do |entity|
      entity = new(entity)
      entity.load_default_values(DATA_MAPPING["default"][entity_type])
      entities << entity
    end
    entities
  end


  def load_default_values(data)
    if data
      data.each do |key, property|
      instance_variable_set("@#{key}", property)
      end
    end
  end


  def to_multipart_hash
    instance_variables.each_with_object({}) do |var, hash|
      key = var.to_s.delete("@")
      value = instance_variable_get(var)

      case value
      when Array
        value.each do |val|
          if val.is_a?(Hash)
            # Use `[]` to denote array elements for hashes
            val.each do |subkey, subvalue|
              hash["#{key}[][#{subkey}]"] = subvalue
            end
          else
            hash["#{key}[]"] = val
          end
        end
      when Hash
        # Flatten the hash into form fields with keys like "key[subkey]"
        value.each do |subkey, subvalue|
          hash["#{key}[#{subkey}]"] = subvalue
        end
      else
        # Default case: assign the value directly
        hash[key] = value
      end
    end
  end




  def self.sparql_query(query, accept_format = 'application/sparql-results+json')
    uri = URI.parse("#{LOV_ENDPOINT}/sparql")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri.scheme == 'https'

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data('query' => query)
    request['Accept'] = accept_format
    response = http.request(request)
    case response
    when Net::HTTPSuccess
      accept_format == 'application/sparql-results+json' ? parse_json_response(response.body) : response.body
    else
      raise "SPARQL query failed: #{response.code} #{response.message}"
    end
  end

  def self.build_sparql_query(data)
    select_vars = []
    where_clauses = []

    data.each do |key, properties|
      var_name = "_#{key}"
      lov_type = properties["lov_type"]
      lang_filter = case properties["lang"]
                      when "en"
                        "FILTER(LANG(?#{var_name}) = \"en\")"
                      when "other"
                        "FILTER(LANG(?#{var_name}) != \"en\")"
                      else
                        ""  # No language filter for any language
      end        
      pattern = "?#{properties["lov_class"]} #{lov_type} ?#{var_name}. #{lang_filter}"
    
      # Add to SELECT clause with GROUP_CONCAT
      select_vars << "(GROUP_CONCAT(DISTINCT ?#{var_name}; separator=\",\") AS ?#{key})"
    
      # Wrap in OPTIONAL {} if optional is set to true
      if properties["optional"]
        where_clauses << "OPTIONAL { #{pattern} }"
      else
        where_clauses << pattern
      end
end
    # only query Vocabs of the selected target portal
    vocabsAcronymFilter = ""
    p vocabsAcronyms
    if vocabsAcronyms

vocabsAcronymFilter = "VALUES ?acronym { #{vocabsAcronyms.map { |ontology| "\"#{ontology}\"" }.join(" ")} }"
    elsif @@targetPortal
      targetPortalVocabs = target_portal_dispatch_vocabs.map { |ontology| "\"#{ontology}\"" }.join(" ")
      vocabsAcronymFilter = "VALUES ?acronym { #{targetPortalVocabs} }"
    end

      # Combine parts into a SPARQL query
      <<-SPARQL
      PREFIX dcterms: <http://purl.org/dc/terms/>
      PREFIX vann: <http://purl.org/vocab/vann/>
      PREFIX voaf: <http://purl.org/vocommons/voaf#>
      PREFIX foaf: <http://xmlns.com/foaf/0.1/>

      ### Vocabularies contained in LOV and their prefix
      SELECT DISTINCT #{select_vars.join(" ")} {
        ?catalog foaf:primaryTopic ?Vocabulary.
        ?Vocabulary a voaf:Vocabulary.

        #{where_clauses.join("\n  ")}
        #{vocabsAcronymFilter}
      } GROUP BY #{DATA_MAPPING["group_by"][self.type]} ORDER BY (?released)
      SPARQL
  end
  # This is used to upload an entity (Agent, Ontology, Submission)
  def upload
    url = URI.parse(LOVPORTAL_ENDPOINT)
    
    request = Net::HTTP::Post.new("#{url}/#{self.class.upload_endpoint}")
    request['Authorization'] = "Authorization: apikey token=#{ENV['API_KEY']}"
    request['content-type'] = 'multipart/form-data'
  
    # Set form data
    form_data = to_multipart_hash
    request.set_form form_data, 'multipart/form-data'

    # Execute the request
    response = Net::HTTP.start(url.hostname, url.port) do |http|
      http.request(request)
    end
  end
  def self.parse_json_response(response_body)
    JSON.parse(response_body)["results"]["bindings"]
  end

end