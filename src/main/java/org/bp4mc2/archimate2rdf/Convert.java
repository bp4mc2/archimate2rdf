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

    if (args.length >1) {

      LOG.info("Starting conversion");
      LOG.info("Input file:  {}",args[0]);
      LOG.info("Output file: {}",args[1]);      

      File inputFile = new File(args[0]);
      File outputFile = new File(args[1]);
      File stylesheetFile = null;
      String domain = null;
      String images = null;
      Boolean skos = false;
      for (int i = 0; i < args.length; i++) {
        if (args[i].startsWith("domain=")) {
          domain = args[i].substring(7);
          LOG.info("Domain:  {}", domain);
        } else if (args[i].equals("-skos")) {
          skos = true;
          LOG.info("Generate SKOS");
        } else if (args[i].startsWith("stylesheet=")) {
          stylesheetFile = new File(args[i].substring(11));
          LOG.info("Stylesheet:  {}", args[i].substring(11));
        } else if (args[i].startsWith("images=")) {
          images = args[i].substring(7);
          LOG.info("Images:  {}", args[i].substring(7));
        }
      }

      try {
        if (stylesheetFile != null) {
          XmlEngine.transform(new StreamSource(inputFile),new StreamSource(stylesheetFile),new StreamResult(outputFile), domain, images, skos);
        } else {
          XmlEngine.transform(new StreamSource(inputFile),"xsl/archimate2rdf.xsl",new StreamResult(outputFile), domain, images, skos);
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
          XmlEngine.transform(new StreamSource(inputFile), "xsl/xsd2owl.xsl",new StreamResult(outputFile), null, null, false);
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
      LOG.info("Usage: archimate2rdf <input.xml> <output.xml> [-skos] [domain=<domain>] [stylesheet=<stylesheet>] [images=<images>]");
    }
  }
}
