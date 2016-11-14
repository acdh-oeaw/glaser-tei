This Repo contains the code of Glaser-TEI. The purpose of the web application Glaser-TEI is to facilitate the TEI encoding of transliteration from the so called 'Glaser Abklatsche'.

# Workflow

## import data

Go to `import-documents.html` and hit the `import` button.
This will trigger a script called totei:triggerBatchTrans. This script will fetch all documents from adlib which have been marked as ready, check if this document is already stored in Glaser-TEI at `data/imported` and if not, it will fetch the adlibXML, transform it with the stylesheet `resources/xslt/adlibXMLtoTEI.xsl` into a basic XML/TEI document. 

## enhance data

`resources/xslt/adlibXMLtoTEI.xsl` does not much more then mapping (some) fields of adlibXML to the TEI data model but doesn't do anything with the actual transliteration. 