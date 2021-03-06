# encoding: utf-8
require 'date'
require_relative "school_holidays/school_holiday"
require 'benchmark'

module SchoolHolidays
  
  DE_REGION_MAPPING = {
    "Baden-Württemberg"       => :de_bw,
    "Bayern"                  => :de_by,
    "Berlin"                  => :de_be,
    "Brandenburg"             => :de_bb,
    "Bremen"                  => :de_hb,
    "Hamburg"                 => :de_hh,
    "Hessen"                  => :de_he,
    "Mecklenburg-Vorpommern"  => :de_mv,
    "Niedersachsen"           => :de_ni,
    "Nordrhein-Westfalen"     => :de_nw,
    "Rheinland-Pfalz"         => :de_rp,
    "Saarland"                => :de_sl,
    "Sachsen"                 => :de_sn,
    "Sachsen-Anhalt"          => :de_st,
    "Schleswig-Holstein"      => :de_sh,
    "Thüringen"               => :de_th
  }                                    
  
  @@regions = []
  @@data = []
  @@school_holiday_types = []  
  
  # Get all school holidays on a given date.
  #
  # <tt>date</tt>::     A Date object.
  # <tt>:options</tt>:: One or more region symbols
  #
  # Returns an array of SchoolHoliday objects
  #
  def self.on(date, *options)   
  end
  
  # Returns all the regions for ex. :de_he
  def self.regions
    @@regions
  end

  # Returns all SchoolHoliday Objects
  def self.data
    @@data
  end
  
  # Returns all types for ex. "Herbstferien"
  def self.school_holiday_types
    @@school_holiday_types
  end
  
  # Get a school holiday
  #
  # <tt>name</tt>::     For ex Herbstferien
  # <tt>year</tt>::
  # <tt>region</tt>::
  def self.by_name(name, year, region)
    @@data.find { |school_holiday| school_holiday.by_name(name, year, region) }  
  end
  
  # Get a school holiday
  #
  # <tt>year</tt>::
  # <tt>region</tt>::
  def self.by_year(year, region)
    @@data.select do |school_holiday| 
      school_holiday.year == year && school_holiday.region == region
    end
  end  
  
  def self.on?(date, region)
    back = false
    result = @@data.find { |school_holiday| school_holiday.cover?(date, region) }
    back = true if result
    back
  end
  
  def self.on_holidays?(date, region, year)
    back = false
    school_holidays = self.by_year(year, region)
    school_holidays.each do |school_holiday|
      break if back
      result = school_holiday.cover?(date, region)
      back = true if result
    end
    back
  end  
  
  def self.included(base)
    f = File.expand_path(File.dirname(__FILE__) + "/../data/de.yml")   
    german = YAML.load_file(f)
    parse_data german
  end
  
  def self.parse_data(data)
    Benchmark.bm(10) do |x| 
      x.report('PARSE') do
        data['school'].each do |year, holiday|
          holiday.each do |name, region|
            @@school_holiday_types << name unless @@school_holiday_types.include? name        
            region.each do |data|       
              r = data['region'].to_sym
              @@regions << r unless @@regions.include? r
              @@data << SchoolHoliday.new(
                          :year => year, 
                          :name => name, 
                          :region => data['region'].to_sym, 
                          :from => data['from'], 
                          :to => data['to']
                        )
                                                           
            end          
          end
        end
      end                      
    end
  end  
end  

class Date
  include SchoolHolidays

  # Check if the current date is a school holiday.
  #
  # Returns true or false.
  #
  #   Date.civil('2012-10-15').holiday?(:de_he)
  #   => true
  def school_holiday?(region)                  
    SchoolHolidays.on?(self, region)
  end
  
end