package org.bp4mc2.archimate2rdf;

import java.io.File;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Convert {

  private static final Logger LOG = LoggerFactory.getLogger(Convert.class);

  public static void main(String[] args) {

    if (args.length == 2) {

      LOG.info("Starting conversion");
      LOG.info("Input file: {}",args[0]);
      LOG.info("Ouput file: {}",args[1]);

      File inputFile = new File(args[0]);
      File outputFile = new File(args[1]);

      try {
        XmlEngine.transform(new StreamSource(inputFile), "xsl/archimate2rdf.xsl",new StreamResult(outputFile));
        LOG.info("Done!");
      }
      catch (Exception e) {
        LOG.error(e.getMessage(),e);
      }
    } else if (args.length == 1) {
      if (args[0].equals("-o")) {
        LOG.info("Starting xsd conversion");
        File inputFile = new File("data/archimate3_Model.xsd");
        File outputFile = new File("data/archimate.ttl");
        try {
          XmlEngine.transform(new StreamSource(inputFile), "xsl/xsd2owl.xsl",new StreamResult(outputFile));
          LOG.info("Done!");
        }
        catch (Exception e) {
          LOG.error(e.getMessage(),e);
        }
      } else {
        LOG.error("Unknown option: {}",args[0]);
      }
    } else {
      LOG.info("Usage: archimate2rdf <input.xml> <output.xml>");
    }
  }
}
