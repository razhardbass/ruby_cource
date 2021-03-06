# frozen_string_literal: true

require_relative 'route.rb'
require_relative 'station.rb'
require_relative 'train.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'company_name.rb'

class RailRoad
  attr_reader :stations
  COMPLITION = '--' * 60
  def initialize
    @routes = []
    @stations = []
    @trains = []
  end

  def start_programm
    loop do
      action_request
      response_action
    end
  end

  def action_request
    puts COMPLITION
    puts 'Салам алейкум!'
    puts 'Введите 1, если нужно создать станцию'
    puts 'Введите 2, если нужно создать поезд'
    puts 'Введите 3, если нужно создать/изменить маршрут'
    puts 'Введите 4, если нужно назначить маршрут поезду'
    puts 'Введите 5, если нужно добавить вагоны к поезду'
    puts 'Введите 6, если нужно отцепить вагоны от поезда'
    puts 'Введите 7, если нужно переместить поезд по маршруту'
    puts 'Введите 8, если нужно просмотреть список станций и список поездов на станции'
    puts COMPLITION
  end

  def response_action
    case gets.to_i
    when 1
      create_new_station
    when 2
      create_new_train
    when 3
      route_options
    when 4
      assign_route
    when 5
      add_wagon
    when 6
      delete_wagon
    when 7
      train_movement
    when 8
      show_station
    else
      puts 'Не корректный ввод, введите число от 1 до 8'
    end
  end

  def create_new_station
    puts 'Введите имя станции'
    name = gets.chomp.to_s
    @stations << Station.new(name)
    puts 'Cозданные станции :'
    show_array(@stations)
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_new_train
    puts 'Введите номер поезда'
    number = gets.chomp
    puts 'Если поезд пассажирский нажмите 1, если грузовой 2'
    case gets.to_i
    when 1
      @trains << PassengerTrain.new(number)
    when 2
      @trains << CargoTrain.new(number)
    end
    puts 'Созданные поезда :'
    show_array(@trains)
  rescue StandardError => e
    puts e.message
    retry
  end

  def route_options
    loop do
      route_request
      route_action
    end
  end

  def route_request
    puts COMPLITION
    puts 'Введите 1, если нужно создать маршрут'
    puts 'Введите 2, если нужно добавить станцию к маршруту'
    puts 'Введите 3, если нужно удалить станцию из маршрута'
    puts 'Введите 0, если нужно выйти в главное меню'
    puts COMPLITION
  end

  def route_action
    case gets.to_i
    when 1
      create_new_route
    when 2
      add_station_to_route
    when 3
      delete_station_from_route
    when 0
      start_programm
    end
  end

  def create_new_route
    puts 'Введите первую станцию маршрута'
    show_array(@stations)
    first = choose_from_array(@stations)
    puts 'Введите последнюю станцию маршрута'
    last = choose_from_array(@stations)
    return if first.nil? || last.nil?

    @routes << Route.new(first, last)
    puts 'Ваши маршруты :'
    show_array(@routes)
  rescue StandardError => e
    puts e.message
    retry
  end

  def add_station_to_route
    puts 'Выберите маршрут по номеру'
    show_array(@routes)
    route = choose_from_array(@routes)
    return if route.nil?

    puts 'Выберите станцию по номеру'
    show_array(@stations)
    name = choose_from_array(@stations)
    route.add_station(name)
    puts 'Текущий маршрут :'
    show_array(route.way)
  end

  def delete_station_from_route
    puts 'Выберите маршрут по номеру'
    show_array(@routes)
    route = choose_from_array(@routes)
    return if route.nil?

    puts 'Выбирите станцию по номеру'
    show_array(@stations)
    name = choose_from_array(@stations)
    route.delete_station(name)
    puts 'Текущий маршрут :'
    show_array(route.way)
    puts COMPLITION
  end

  def assign_route
    puts 'Выбирите поезд:'
    show_array(@trains)
    train = choose_from_array(@trains)
    return if train.nil?

    puts 'Выбирите маршрут:'
    show_array(@routes)
    route = choose_from_array(@routes)
    return if route.nil?

    train.train_way(route)
    puts 'Текущий маршрут:'
    show_array(route.way)
    puts COMPLITION
  end

  def add_wagon
    puts 'Выберите поезд к которому добавить вагон:'
    show_array(@trains)
    train = choose_from_array(@trains)
    return if train.nil?

    train.type == 'passenger' ? train.add_wagons(PassengerWagon.new) : train.add_wagons(CargoWagon.new)
    puts "Список вагонов у поезда : #{train.wagons}"
    puts COMPLITION
  end

  def delete_wagon
    puts 'Выберите поезд у которого отцепить вагон: '
    show_array(@trains)
    train = choose_from_array(@trains)
    return if train.nil?

    train.delete_wagons
    puts "Список вагонов у поезда : #{train.wagons}"
    puts COMPLITION
  end

  def train_movement
    puts 'Выберите поезд для движения :'
    show_array(@trains)
    train = choose_from_array(@trains)
    return if train.nil?
    return if @routes.empty?

    puts 'Нажмите 1, если хотите отправить поезд вперед'
    puts 'Нажмите 2, если хотите отправить поезд назад'
    case gets.to_i
    when 1
      train.go
    when 2
      train.back
    end
    puts "Текущая станция #{train.current_station}"
    puts COMPLITION
  end

  def show_station
    puts 'Выберите станцию для получения информации :'
    show_array(@stations)
    station = choose_from_array(@stations)
    return if station.nil?

    puts 'Поезда на станции:'
    show_array(station.train_list)
    puts COMPLITION
  end

  def show_array(array)
    array.each_with_index do |element, index|
      puts "#{index + 1}) #{element}"
    end
  end

  def choose_from_array(array)
    index = gets.to_i
    return unless index.positive?

    array[index - 1]
  end
end

RailRoad.new.start_programm
