require 'spreadsheet'                              
require 'yaml'
require_relative 'lib/school_holidays'
require_relative 'lib/school_holidays/school_holiday'  

def add_data(data, name)
  unless data[name]
    data[name] = []
  end        
end

book = Spreadsheet.open 'ferien.xls'
sheet1 = book.worksheet 0

output = {}
output["school"] = {}
by_region = {}

6.upto(261) do |n|     
  #puts "----------- Parsing row #{n} ---------------"
                              
  row = sheet1.row(n)        

  region = row[0]
  year = row[1].to_i        
    
  from_weihnachtsferien = row[13]
  to_weihnachtsferien   = row[2]
  
  from_winterferien     = row[3]  
  to_winterferien       = row[4]    
                        
  from_ostern           = row[5]  
  to_ostern             = row[6]    
                        
  from_pfingsten        = row[7]  
  to_pfingsten          = row[8]    

  from_sommer           = row[9]  
  to_sommer             = row[10]    

  from_herbst           = row[11]  
  to_herbst             = row[12]    
  
  if to_weihnachtsferien.class == String
    to_weihnachtsferien = Date.parse("1.1.#{year}")
  end    
  
  #puts "- #{region} - #{year} | (#{from_weihnachtsferien} - #{to_weihnachtsferien}) | (#{from_winterferien} - #{to_winterferien}) | (#{from_ostern} - #{to_ostern}) | (#{from_pfingsten} - #{to_pfingsten}) | (#{from_sommer} - #{to_sommer}) | (#{from_herbst} - #{to_herbst}) |"
  iso = SchoolHolidays::DE_REGION_MAPPING[region]
  
  r = by_region[iso]
  unless r
    r = Hash.new
    by_region[iso] = r
  end     

  y = by_region[iso][year]
  unless y
    d = Hash.new
    by_region[iso][year] = d
  end
  
  add_data(by_region[iso][year], "Winterferien")
  add_data(by_region[iso][year], "Weihnachtsferien")
  add_data(by_region[iso][year], "Osterferien")
  add_data(by_region[iso][year], "Pfingstferien")    
  add_data(by_region[iso][year], "Sommerferien")    
  add_data(by_region[iso][year], "Herbstferien")      
  
  by_region[iso][year]["Winterferien"]     << { "from" => from_winterferien, "to" => to_winterferien } if from_winterferien.class == Date                
  by_region[iso][year]["Osterferien"]      << { "from" => from_ostern, "to" => to_ostern } if from_ostern.class == Date    
  by_region[iso][year]["Pfingstferien"]    << { "from" => from_pfingsten, "to" => to_pfingsten } if from_pfingsten.class == Date        
  by_region[iso][year]["Sommerferien"]     << { "from" => from_sommer, "to" => to_sommer } if from_sommer.class == Date          
  by_region[iso][year]["Herbstferien"]     << { "from" => from_herbst, "to" => to_herbst } if from_herbst.class == Date            
  by_region[iso][year]["Weihnachtsferien"] << { "from" => from_weihnachtsferien, "to" => to_weihnachtsferien } 
end

#correct Weihnachtsferien
by_region.each_key do |iso|
  by_region[iso].each_key do |year|                    
    if year > 2002 && year < 2017
      before_weihnachtsferien = by_region[iso][year+1]["Weihnachtsferien"]    
      weihnachtsferien = by_region[iso][year]["Weihnachtsferien"]  
      weihnachtsferien[0]["to"] = before_weihnachtsferien[0]["to"]             
    end
  end
end                                                                              

by_region.each_key do |iso|
  by_region[iso].each_key do |year|                    
    data = output["school"][year]  
    unless data
      data = Hash.new
      output["school"][year] = data                                          
    end
    
    add_data(data, "Winterferien")
    add_data(data, "Weihnachtsferien")
    add_data(data, "Osterferien")
    add_data(data, "Pfingstferien")    
    add_data(data, "Sommerferien")    
    add_data(data, "Herbstferien")                                                                    
    
    by_region[iso][year].each_key do |ferien|
      if by_region[iso][year][ferien]      
        d = by_region[iso][year][ferien]                
        if d.size > 0
          from = by_region[iso][year][ferien][0]["from"]      
          to = by_region[iso][year][ferien][0]["to"]            
          data[ferien] << { "region" => iso, "from" => from, "to" => to }
        end
      end
    end
  end
end                                                                              

output["school"].delete 2002
output["school"].delete 2017
File.open("data/de.yml", 'w') {|f| f.write(output.to_yaml) }