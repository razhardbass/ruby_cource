# frozen_string_literal: true
require_relative 'company_name.rb'
require_relative 'instance_counter.rb'

class Train
  include CompanyName
  include InstanceCounter
  attr_reader :number, :speed, :wagons

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    register_instance
  end

  def self.find(number)
    @trains.each do |element| 
      puts "#{element}" if element == number.to_i
    end
  end

  def acceleration(speed)
    self.speed += speed
  end

  def brake
    @speed = 0
  end

  def add_wagons(wagon)
    return unless self.type == wagon.type
    @wagons << wagon if speed.zero?
  end

  def delete_wagons
    @wagons.pop if speed.zero?
  end

  def train_way(route)
    @index = 0
    @route = route
    current_station.add_train(self)
  end

  def current_station
    @route.way[@index]
  end

  def next_station
    @route.way[@index + 1]
  end

  def previous_station
    @route.way[@index - 1] if @index.positive?
  end

  def go
    return unless next_station

    current_station.send_a_train(self)
    next_station.add_train(self)
    @index += 1
  end

  def back
    return unless previous_station

    current_station.send_a_train(self)
    previous_station.add_train(self)
    @index -= 1
  end

  def to_s
    @number
  end

end
