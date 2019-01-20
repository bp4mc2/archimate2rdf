package org.bp4mc2.archimate2rdf;

import java.io.File;
import java.io.FileOutputStream;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.riot.RDFDataMgr;
import org.apache.jena.riot.RDFFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Convert {

  private static final Logger LOG = LoggerFactory.getLogger(Convert.class);

  public static void main(String[] args) {

    if ((args.length == 2) || (args.length == 3)) {

      LOG.info("Starting conversion");
      LOG.info("Input file:  {}",args[0]);
      LOG.info("Output file: {}",args[1]);
      if (args.length == 3) {
        LOG.info("Stylesheet:  {}",args[2]);
      }

      File inputFile = new File(args[0]);
      File outputFile = new File(args[1]);
      File stylesheetFile = null;
      if (args.length == 3) {
        stylesheetFile = new File(args[2]);
      }

      try {
        if (stylesheetFile != null) {
          XmlEngine.transform(new StreamSource(inputFile),new StreamSource(stylesheetFile),new StreamResult(outputFile));
        } else {
          XmlEngine.transform(new StreamSource(inputFile),"xsl/archimate2rdf.xsl",new StreamResult(outputFile));
        }
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
          //Transform to ttl
          XmlEngine.transform(new StreamSource(inputFile), "xsl/xsd2owl.xsl",new StreamResult(outputFile));
          //Transform original outputFile to different formats
          Model model = RDFDataMgr.loadModel("data/archimate.ttl");
          RDFDataMgr.write(new FileOutputStream("data/archimate.json"),model, RDFFormat.JSONLD_COMPACT_PRETTY);
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
