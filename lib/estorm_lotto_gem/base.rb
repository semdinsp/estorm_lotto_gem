require 'rubygems'

module Randprize
  class Base
    attr_accessor :randgen, :myrange
  def debug
    true
  end
  def initialize
    # puts "Running a few random numbers to settle random generator"
    1.upto(10000) {|i| self.rand }
  end
  def random_generator
    self.randgen=Random.new if self.randgen==nil
    self.randgen
  end
  def set_random_generator(r)
    self.randgen=r
  end
  
  def rand
    self.random_generator.rand
  end
  def set_range(range)
    self.myrange=range
  end
 
  def random_range
    self.random_generator.rand(self.myrange)
  end

   end    # Class
end    #Module