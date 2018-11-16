#!/usr/bin/ruby

require_relative 'map'
require_relative 'zombie'
require_relative 'util'

ZOMBIE_KILLS_PER_TICK = 1

puts "Welcome to zombies!\n"

width = 160
height = 38
map = Map.new(width, height)

zombie_count = 5
human_count = 100

(1..zombie_count).each do |i|
  zombie = Zombie.new("zombie#{i}", map)
  x, y = map.get_free
  map.add(zombie, x, y)
end

(1..human_count).each do |i|
  human = Human.new("human#{i}", map)
  x, y = map.get_free
  map.add(human, x, y)
end

puts map
sleep 5

count = 0
while map.has_living
  count += 1
  puts map
  map.turn
  sleep(0.1)
end

puts "Termino luego de #{count} ."
