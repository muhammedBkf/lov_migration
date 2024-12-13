DATA_MAPPING = {
  "Ontology" => {
    "acronym" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "vann:preferredNamespacePrefix",
      "optional" => false,
      "pk" =>true   
    },
    "name" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcterms:title",
      "lang" => "en",
      "optional" => false
    },
  },
  
  "Submission" => {
    "acronym" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "vann:preferredNamespacePrefix",
      "optional" => false,
      "pk" => true,
    },
    "description" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcterms:description",
      "lang" => "en",
      "optional" => false
    },
    "URI" => {
      "lov_class" => "catalog",
      "lov_type" => "foaf:primaryTopic",
      "optional" => false,
    },
    "released" => {
      "lov_class" => "Distribution",
      "lov_type" => "dcterms:issued",
      "optional" => false,
      "pk" =>true
    },
    "pullLocationn" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "<http://www.w3.org/ns/dcat#distribution>",
      "optional" => false,
      "pk" => true
    },
    "homepage" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "foaf:homepage",
      "optional" => true,
    },
    "metadataVoc" => {
      "lov_class" => "Distribution",
      "lov_type" => "voaf:metadataVoc",
      "optional" => true,
      "isArray" => true
    },
    "keywords" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcat:keyword",
      "optional" => true,
      "isArray" => true
    },
    # Agents 
    "hasContributor" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcat:keyword",
      "optional" => true,
      "isArray" => true
    },
    # Relations
    "generalizes" => {
      "lov_class" => "Distribution",
      "lov_type" => "voaf:generalizes",
      "optional" => true,
      "isArray" => true
    },
    "explanationEvolution" => {
      "lov_class" => "Distribution",
      "lov_type" => "voaf:specializes",
      "optional" => true,
      "isArray" => true
    },
  },
  
  "default" => {
    "Ontology" => {
      "administeredBy" => ["admin"]
    },
    "Submission" => {
      "hasOntologyLanguage" => "OWL",
      "status" => "production",
      "contact" => ["name":"admin","email":"admin@admin.com"],
      "includedInDataCatalog" => ["https://lov.linkeddata.es/dataset/lov"],
    },
    "Agent" => {
      "creator" => "admin"
    }
  },
}
