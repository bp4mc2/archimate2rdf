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

  public static void transform(StreamSource source, String xslResource, StreamResult result)
      throws TransformerConfigurationException,TransformerException {

    transform(source,xslResource,result,null);

  }

  public static void transform(StreamSource source, String xslResource, StreamResult result,
      Object input) throws TransformerConfigurationException,TransformerException {

    // Set resolver, only ones
    if (uriResolver == null) {
      uriResolver = new ClassPathResourceUriResolver();
      tfactory.setURIResolver(uriResolver);
    }

    // Create input stream for the actual resource
    InputStream xslStream = XmlEngine.class.getClassLoader().getResourceAsStream(xslResource);

    // Create a transformer for the stylesheet.
    Transformer transformer = tfactory.newTransformer(new StreamSource(xslStream));

    // Set parameter, if any
    if (input != null) {
      transformer.setParameter("args",input);
    }

    // Transform the source XML
    transformer.transform(source, result);

  }

}
