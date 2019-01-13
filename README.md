# archimate2rdf
Translating the ArchiMate Model Exchange File Format to RDF

The Open Group has published the ArchiMate Model Exchange File format - a standard file format for the exchange of ArchiMate models between different tools. Resources can be found at: https://www.opengroup.org/open-group-archimate-model-exchange-file-format

## Usage

`java -jar archimate2rdf.jar <input.xml> <output.xml>`

## Ontology

The ontology we use can be found here: http://bp4mc2.org/def/archimate

Unfortunately, no official archimate ontology exists. Different initiatives have been undertaken (listed below - as far as we know), but all these initiatives are the result a transformation effort. And for that, you need a target ontology! Our own target ontology is nothing better: something we need to translate the archimate exchange file format to.

> We urge the Open Group to publish the archimate ontology at their own namespace! We welcome them to use ours, or one of the other ontologies mentioned below. Please :-)

### Other efforts

Some other people have tried to create an archimate ontology, or mention the need for one:

- https://www.linkedin.com/pulse/from-archimate-language-web-ontology-dr-nicolas-figay
- https://github.com/nfigay/archimate.owl
- https://github.com/archimatetool/OWLExchange
- https://forum.archimatetool.com/index.php?topic=309.0
- https://github.com/ikm-group/ArchiMEO/blob/master/ARCHIMEO/ARCHIMATE/ArchiMate.ttl

## Mapping

We used the ArchiMate Model Exchange File format to create the transformation. The reason we used this file format is:

1. It's a standard - a clear meaning is understood;
2. It's tool independent - any body could use our transformation software, regardless of the tool used;
3. It's an XML format, so transformation using XSL is quite straightformard and easy understood.

The actual transformation XSL can be found here: [src/main/java/resources/xsl/archimate2.rdf](https://github.com/bp4mc2/archimate2rdf/blob/master/src/main/java/resources/xsl/archimate2rdf.xsl)

The follow rules were followed for the transformation:
- An ArchiMate modeling construct is formalized as an OWL Class;
- An ArchiMate relation is formalized as an OWL ObjectProperty (lowerCamelCase).
- A name of an ArchiMate modeling construct or relation is formalized as a rdfs:label property;
- A description of an Archimate modeling construct or relation is formalized as a rdfs:comment property;
