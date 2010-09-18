require 'xmlsimple'

class N2vController < ApplicationController

  respond_to :html, :vcard
  def index
  end
  
  def create    
    # read the file
    file = params[:uploaded_file]
    @data = File::open(file).read
    file.close
    
    @doc   = XmlSimple.xml_in(@data)
    
    # init variables
    @cells = []
    @document=[]
    @matrix = []
    
    # parse the xml-document
    @doc.each do |element| 
      tag = element[0].to_s 
      if tag == 'workspace-array'
         workspace = element[1][0]['workspace'] 
         workspace.each do |ws| 
           ws['page-info'][0]\
                 ['layers'][0]\
                   ['layer'][0]\
                     ['drawables'][0]\
                       ['tabular-info'][0]\
                         ['tabular-model'][0]\
                           ['grid'][0]\
                             ['datasource'][0].each do |cells| 
              record = {}
              cells.each do |cell|
                if cell.class != Array
                  type = cell.to_sym
                  record[:type] = type
                else
                  record[:rows] = cell.map { |c|
                    c
                  }
                end
              end
              if record[:type].to_s =~ /text-cell/
                @document << record[:rows].map {|r|
                   {:col => r['sf:col'].to_i, :row => r['sf:row'].to_i,:type => 'text', :value => r['cell-text'][0]['sfa:string'].to_s } 
                }
              elsif record[:type].to_s =~ /generic-cell/
                @document << record[:rows].map {|r|
                   {:col => r['sf:col'].to_i, :row => r['sf:row'].to_i, :type => 'generic', :value => r.inspect } 
                }
              elsif
                record[:type].to_s =~ /date-cell/
                  @document << record[:rows].map {|r|
                     {:col => r['sf:col'].to_i, :row => r['sf:row'].to_i, :type => 'date', :value => Date.parse(r['sf:cell-date']).strftime("%Y-%m-%d")  } 
                }
              else
                @document << {  :unhandeled => record.inspect }
              end
           end 
         end 
       end 
     end 
     
    @document.each do |cells|
      cells.each do |cell|
        begin
          unless @matrix[cell[:row].to_i]
             @matrix[cell[:row].to_i] = []
          end
          unless @matrix[cell[:col].to_i]
             @matrix[cell[:col].to_i] = nil
          end
          @matrix[cell[:row]][cell[:col]] = cell[:value].to_s
        rescue 
        end
      end
    end
    @matrix.reject!{|d| d.blank? }
    @fieldnames = @matrix[0]
    @records= @matrix[1..-1]
    respond_to do |format|
        format.vcard  { 
          send_data(render_to_string( :vcard => @records), :filename => 'addresses.vcf' )
        }
      end
   end
   
end
