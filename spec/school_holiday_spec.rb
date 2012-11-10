require 'spec_helper'
require 'school_holidays'

describe SchoolHolidays do
  
  it 'should parse the regions' do
    SchoolHolidays.regions.sort!.should == [:de_bb, :de_be, :de_bw, :de_by, :de_hb, :de_he, :de_hh, :de_mv, :de_ni, :de_nw, :de_rp, :de_sh, :de_sl, :de_sn, :de_st, :de_th]  
  end
  
  it 'should parse the types' do
    SchoolHolidays.school_holiday_types.sort!.should == ["Herbstferien", "Osterferien", "Pfingstferien", "Sommerferien", "Weihnachtsferien", "Winterferien"]    
  end
  
  it 'should have objects of type SchoolHoliday' do
    SchoolHolidays.data.each { |d| d.class.should == SchoolHoliday }
  end

  it 'should have school_holiday objects' do
    SchoolHolidays.data.size > 0
  end
  
  it 'should get Herbstferien for Hessen 2012' do
    herbstferien = SchoolHolidays.by_name("Herbstferien", 2012, :de_he)
    herbstferien.class.should == SchoolHoliday
    herbstferien.name.should == "Herbstferien"
  end

  it 'should get Sommerferien for BW 2012' do
    herbstferien = SchoolHolidays.by_name("Sommerferien", 2012, :de_bw)
    herbstferien.class.should == SchoolHoliday
    herbstferien.name.should == "Sommerferien"
  end
                                                             
  context "Hessen" do
    it 'should be a school holiday' do
      Date.parse('2012-10-15').school_holiday?(:de_he).should == true
    end

    it 'should be no school holiday' do
      Date.parse('2012-11-1').school_holiday?(:de_he).should == false
    end    
  end

  context "Bayern" do
    it 'should be a school holiday' do
      Date.parse('2012-8-10').school_holiday?(:de_by).should == true
    end

    it 'should be no school holiday' do
      Date.parse('2012-11-5').school_holiday?(:de_by).should == false
    end    
  end
  
end