DATA_MAPPING = {
  "Ontology" => {
    "acronym" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "vann:preferredNamespacePrefix",
      "optional" => false
    },
    "name" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcterms:title",
      "lang" => "en",
      "optional" => false
    }
  },
  "Submission" => {
    "description" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcterms:description",
      "lang" => "en",
      "optional" => false
    },
    "URI" => {
      "lov_class" => "catalog",
      "lov_type" => "foaf:primaryTopic",
      "optional" => false
    }
  },
  
  "default" => {
    "Ontology" => {
      "administeredBy" => ["admin"]
    },
    "Submission" => {
      "hasOntologyLanguage" => "OWL",
      "status" => "production"
    },
    "Agent" => {
      "creator" => "admin"
    }
  }
}
