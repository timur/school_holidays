require 'yaml'
require_relative 'lib/school_holidays'
require_relative 'lib/school_holidays/school_holiday'

require 'benchmark'

start_date = Date.parse('2012-1-1')
end_date   = Date.parse('2012-12-31')

Benchmark.bm(10) do |x|
  x.report('Year 2012') do
    start_date.upto(end_date) do |date|
      date.school_holiday?(:de_he)
    end
  end
end