== convert a Numbers-Document to Addressbook-VCards for import

  A little helper by Andreas Altendorfer <andreas@altendorfer.at>
  Version 0, 2010-09-18
  
  Use it for free without any warranty!

=== Extract the XML-File from your Numbers-Document

  1. Open "Package" of your Numbers-Document and locate a file named "index.xml.gz"
  2. Unzip this file to index.xml or any other name
  3. cd to the app-directory
  4. bundle install
  5. rails server
  6. open http://0.0.0.0:3000 with your web-browser
  7. Upload the index.html file
  8. A file named addresses.vcf will be downloaded to your Download-folder
     - if enabled this file will be imported to Addressbook immediately
     
=== Requirements for your Numbers-document

  - There should be one table only
  - The first row should be the header-row (Names of columns though names doesn't matter)
  - The columns should be arranged as explained below
  
If you want to change the columns see app/views/n2v/create.vcard.erb where the VCard-records will be created.

==== Columns

**The original Numbers Document**:

  -  0 Titel vorangestellt (Kunde)	
  -  1 Nachname (Kunde)	
  -  2 Vorname (Kunde)	
  -  3 GebDatum (Kunde)	
  -  4 Straße (Kunde)	
  -  5 PLZ (Kunde)	
  -  6 Ort (Kunde)	
  -  7 Festnetz privat (Kunde)	
  -  8 Festnetz beruflich (Kunde)	
  -  9 Tel. Mobil (Kunde)	
  - 10 Tel. Sonstig (Kunde)	
  - 11 Fax (Kunde)	
  - 12 Mail (Kunde)	
  - 13 Beruf
 
**The building of the VCards**:
  
   BEGIN:VCARD
   VERSION:3.0
   N:<%=record[1] -%>;<%= record[2] %>;;<%= record[0] %>;
   FN:<%= [record[0],record[2],record[1]].reject{|r| r.blank? }.join(" ") %>
   ORG:<%= record[13].to_s.humanize %>
   TITLE:<%= record[0] %>
   EMAIL;type=INTERNET;type=HOME;type=pref:<%= record[12] %>
   TEL;type=HOME:<%= record[7] %>
   TEL;type=WORK:<%= record[8] %>
   TEL;type=CELL;type=pref:<%= record[9] %>
   TEL;type=OTHER:<%= record[10] %>
   TEL;type=FAX:<%= record[11] %>
   item1.ADR;type=HOME:;;<%= record[4] -%>;<%= record[6] -%>;;<%= record[5] -%>;Austria
   item1.X-ABADR:at
   <% unless record[3].blank? -%>BDAY;value=date:<%= record[3] %><% end %>
   END:VCARD
   
