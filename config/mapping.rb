DATA_MAPPING = {
  "Agent" => {
    "agent" => {
      "lov_class" => "Agent",
      "lov_type" => "foaf:Person",
      "optional" => false,
      "pk" =>true   
    },    
    "agentType" => {
      "lov_class" => "Agent",
      "lov_type" => "vann:preferredNamespacePrefix",
      "optional" => false,
      "pk" =>true   
    },    
    "name" => {
      "lov_class" => "Agent",
      "lov_type" => "foaf:name",
      "optional" => false,
      "pk" =>true   
    },    
    "email" => {
      "optional" => false,
      "pk" =>true   
    },    
    "homepage" => {
      "optional" => false,
      "pk" =>true   
    },
    "sameAs" => {
      "optional" => false,
      "pk" =>true   
    },
  },
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
      "lov_class" => "pullLocationn",
      "lov_type" => "dcterms:issued",
      "optional" => false,
      "pk" =>true
    },
    "version" => {
      "lov_class" => "pullLocationn",
      "lov_type" => "dcterms:title",
      "optional" => false,
      "pk" =>true
    },
    "preferredNamespaceUri" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "vann:preferredNamespaceUri",
      "optional" => false,
      "pk" => false
    },
    "pullLocationn" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "<http://www.w3.org/ns/dcat#distribution>",
      "optional" => false,
      "pk" => true
    },
    "naturalLanguage" => {
      "lov_class" => "pullLocationn",
      "lov_type" => "dcterms:language",
      "optional" => true,
    },
    "homepage" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "foaf:homepage",
      "optional" => true,
    },
    "metadataVoc" => {
      "lov_class" => "pullLocationn",
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
      "lov_type" => "dcterms:contributor",
      "isArray" => true
    },
    "hasCreator" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcterms:creator",
      "isArray" => true
    },    
    "publisher" => {
      "lov_class" => "Vocabulary",
      "lov_type" => "dcterms:publisher",
      "isArray" => true
    },
    # Relations
    "generalizes" => {
      "lov_class" => "pullLocationn",
      "lov_type" => "voaf:generalizes",
      "optional" => true,
      "isArray" => true
    },
    "explanationEvolution" => {
      "lov_class" => "pullLocationn",
      "lov_type" => "voaf:specializes",
      "optional" => true,
      "isArray" => true
    },
    "isAlignedTo" => {
      "lov_class" => "pullLocationn",
      "lov_type" => "voaf:hasEquivalencesWith",
      "optional" => true,
      "isArray" => true
    },
    "ontologyRelatedTo" => {
      "lov_class" => "pullLocationn",
      "lov_type" => "voaf:extends",
      "optional" => true,
      "isArray" => true
    },
    "useImports" => {
      "lov_class" => "pullLocationn",
      "lov_type" => "owl:imports",
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
      "hasOntologySyntax" => "https://www.w3.org/ns/formats/data/N3",
      "isOfType" => "http://omv.ontoware.org/2005/05/ontology#Vocabulary"
    },
    "Agent" => {
      "creator" => "admin"
    }
  },
}
