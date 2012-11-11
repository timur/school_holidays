require 'spreadsheet'                              
require 'yaml'
require_relative 'lib/school_holidays'
require_relative 'lib/school_holidays/school_holiday'

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
  
  data = output["school"][year]  
  unless data
    data = Hash.new
    output["school"][year] = data
  end
    
  from_weihnachtsferien = nil
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
  
  unless data["Winterferien"]
    data["Winterferien"] = []
  end

  unless data["Weihnachtsferien"]
    data["Weihnachtsferien"] = []
  end

  unless data["Osterferien"]
    data["Osterferien"] = []
  end

  unless data["Pfingstferien"]
    data["Pfingstferien"] = []
  end

  unless data["Sommerferien"]
    data["Sommerferien"] = []
  end

  unless data["Herbstferien"]
    data["Herbstferien"] = []
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
    d = Array.new
    by_region[iso][year] = d
  end
  
  by_region[iso][year] = row     
  
  data["Winterferien"]     << { "region" => iso, "from" => from_winterferien, "to" => to_winterferien } if from_winterferien.class == Date                
  data["Osterferien"]      << { "region" => iso, "from" => from_ostern, "to" => to_ostern } if from_ostern.class == Date    
  data["Pfingstferien"]    << { "region" => iso, "from" => from_pfingsten, "to" => to_pfingsten } if from_pfingsten.class == Date        
  data["Sommerferien"]     << { "region" => iso, "from" => from_sommer, "to" => to_sommer } if from_sommer.class == Date          
  data["Herbstferien"]     << { "region" => iso, "from" => from_herbst, "to" => to_herbst } if from_herbst.class == Date            
  data["Weihnachtsferien"] << { "region" => iso, "from" => from_weihnachtsferien, "to" => to_weihnachtsferien }
end

File.open("ferien.yml", 'w') {|f| f.write(output.to_yaml) }