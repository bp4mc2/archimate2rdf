package org.bp4mc2.archimate2rdf;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

public class ClassPathResourceUriResolver implements URIResolver {

  @Override
  public Source resolve(String href, String base) throws TransformerException {
    return new StreamSource(ClassPathResourceUriResolver.class.getClassLoader().getResourceAsStream("xsl/" + href));
  }
}
