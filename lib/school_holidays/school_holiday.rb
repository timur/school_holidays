# encoding: utf-8

# A represntation of a school holiday for a year and region
#
# <tt>year</tt>:: year of the school holiday
# <tt>name</tt>:: the name of the holiday for ex 'Sommerferien'
# <tt>from</tt>:: the from date
# <tt>year</tt>:: the to date
# <tt>region</tt>:: the region for ex 'de_he'
#
# Copyright November 2012, Timur Yalcin.  All Rights Reserved.
#
class SchoolHoliday
  
  attr_reader :year, :name, :from, :to, :region
  
  def initialize(options = {})
    @year = options[:year]
    @name = options[:name]
    @from = options[:from]
    @to = options[:to]
    @region = options[:region]
  end
  
  def range
    from..to
  end
  
  def by_name(name, year, region)
    if @region == region.to_sym && @year == year && @name == name
      return self
    end    
  end
  
  # checks if a given date is in the holiday
  def cover?(date, region)
    if @region == region.to_sym
      return range.cover? date
    else
      return false
    end      
  end                                       
   
end