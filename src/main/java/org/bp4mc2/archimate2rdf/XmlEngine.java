package org.bp4mc2.archimate2rdf;

import java.io.InputStream;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class XmlEngine {

  private static final TransformerFactory tfactory = TransformerFactory.newInstance();

  private static ClassPathResourceUriResolver uriResolver = null;

  public static void transform(StreamSource source, String xslResource, StreamResult result,
      Object input, String images, Boolean skos) throws TransformerConfigurationException,TransformerException {

    // Set resolver, only ones
    if (uriResolver == null) {
      uriResolver = new ClassPathResourceUriResolver();
      tfactory.setURIResolver(uriResolver);
    }

    // Create input stream for the actual resource
    InputStream xslStream = XmlEngine.class.getClassLoader().getResourceAsStream(xslResource);

    transform(source,new StreamSource(xslStream),result,input,images,skos);
  }

  public static void transform(StreamSource source, StreamSource stylesheet, StreamResult result,
      Object input, String images, Boolean skos) throws TransformerConfigurationException,TransformerException {

    // Create a transformer for the stylesheet.
    Transformer transformer = tfactory.newTransformer(stylesheet);

    // Set parameter, if any
    if (input != null) {
      transformer.setParameter("args",input);
    }
    if (images != null) {
      transformer.setParameter("images",images);
    }
    if (skos) {
      transformer.setParameter("skos", "true");
    } else {
      transformer.setParameter("skos","false");
    }

    // Transform the source XML
    transformer.transform(source, result);

  }

}
