/**
 * @file    addCVTerms.java
 * @brief   adds controlled vocabulary terms to a species in a model
 * @author  Akira Funahashi (translated from libSBML C++ examples (using other Java examples provided by Nicolas Rodriguez))
 * @author  Sarah Keating
 *
 * <!--------------------------------------------------------------------------
 * This sample program is distributed under a different license than the rest
 * of libSBML.  This program uses the open-source MIT license, as follows:
 *
 * Copyright (c) 2013-2014 by the California Institute of Technology
 * (California, USA), the European Bioinformatics Institute (EMBL-EBI, UK)
 * and the University of Heidelberg (Germany), with support from the National
 * Institutes of Health (USA) under grant R01GM070923.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * Neither the name of the California Institute of Technology (Caltech), nor
 * of the European Bioinformatics Institute (EMBL-EBI), nor of the University
 * of Heidelberg, nor the names of any contributors, may be used to endorse
 * or promote products derived from this software without specific prior
 * written permission.
 * ------------------------------------------------------------------------ -->
 */


import org.sbml.libsbml.libsbmlConstants;
import org.sbml.libsbml.CVTerm;
import org.sbml.libsbml.SBMLWriter;
import org.sbml.libsbml.Species;
import org.sbml.libsbml.SBMLDocument;
import org.sbml.libsbml.SBMLReader;
 

public class addCVTerms
{
  public static void main (String[] args)
  {        
    if (args.length != 2)
    {
      println("\n  usage: java appendAnnotation <input-filename> <output-filename>");
      println("  Adds controlled vocabulary term to a species\n");
      System.exit(2);
    }

    SBMLDocument d;
    SBMLReader reader     = new SBMLReader();
    SBMLWriter writer     = new SBMLWriter();

    d = reader.readSBML(args[0]);

    long errors = d.getNumErrors();

    if (errors > 0)
    {
      println("Read Error(s):");
      d.printErrors();
      println("Correct the above and re-run.");
    }
    else
    {
      long n = d.getModel().getNumSpecies();

      if (n <= 0)
      { 
        println("Model has no species.\n Cannot add CV terms\n");
      } 
      else
      { 
        Species s = d.getModel().getSpecies(0);

        CVTerm cv = new CVTerm();
        cv.setQualifierType(libsbmlConstants.BIOLOGICAL_QUALIFIER);
        cv.setBiologicalQualifierType(libsbmlConstants.BQB_IS_VERSION_OF);
        cv.addResource("http://www.geneontology.org/#GO:0005892");

        CVTerm cv2 = new CVTerm();
        cv2.setQualifierType(libsbmlConstants.BIOLOGICAL_QUALIFIER);
        cv2.setBiologicalQualifierType(libsbmlConstants.BQB_IS);
        cv2.addResource("http://www.geneontology.org/#GO:0005895");

        CVTerm cv1 = new CVTerm();
        cv1.setQualifierType(libsbmlConstants.BIOLOGICAL_QUALIFIER);
        cv1.setBiologicalQualifierType(libsbmlConstants.BQB_IS_VERSION_OF);
        cv1.addResource("http://www.ebi.ac.uk/interpro/#IPR002394");

        s.addCVTerm(cv);
        s.addCVTerm(cv2);
        s.addCVTerm(cv1);

        writer.writeSBML(d, args[1]);
      }
    }
    System.exit((int)errors);
  }

  static void println (String msg)
  {
    System.out.println(msg);
  }


  /**
   * Loads the SWIG-generated libSBML Java module when this class is
   * loaded, or reports a sensible diagnostic message about why it failed.
   */
  static
  {
    try
    {
      System.loadLibrary("sbmlj");
      // For extra safety, check that the jar file is in the classpath.
      Class.forName("org.sbml.libsbml.libsbml");
    }
    catch (UnsatisfiedLinkError e)
    {
      System.err.println("Error encountered while attempting to load libSBML:");
      System.err.println("Please check the value of your "
                         + (System.getProperty("os.name").startsWith("Mac OS")
                            ? "DYLD_LIBRARY_PATH" : "LD_LIBRARY_PATH") +
                         " environment variable and/or your" +
                         " 'java.library.path' system property (depending on" +
                         " which one you are using) to make sure it list the" +
                         " directories needed to find the " +
                         System.mapLibraryName("sbmlj") + " library file and" +
                         " libraries it depends upon (e.g., the XML parser).");
      System.exit(1);
    }
    catch (ClassNotFoundException e)
    {
      System.err.println("Error: unable to load the file 'libsbmlj.jar'." +
                         " It is likely that your -classpath command line " +
                         " setting or your CLASSPATH environment variable " +
                         " do not include the file 'libsbmlj.jar'.");
      e.printStackTrace();

      System.exit(1);
    }
    catch (SecurityException e)
    {
      System.err.println("Error encountered while attempting to load libSBML:");
      e.printStackTrace();
      System.err.println("Could not load the libSBML library files due to a"+
                         " security exception.\n");
      System.exit(1);
    }
  }
}