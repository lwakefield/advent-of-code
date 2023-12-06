input = (File.read ARGV.first)

seeds                       = input.match(/(?<=seeds: ).+?(?=\n\n)/m).not_nil![0].split.map(&.to_i64)
seed_to_soil_map            = t input.match(/(?<=seed-to-soil map:\n).+?(?=\n\n)/m).not_nil![0]
soil_to_fertilizer_map      = t input.match(/(?<=soil-to-fertilizer map:\n).+?(?=\n\n)/m).not_nil![0]
fertilizer_to_water_map     = t input.match(/(?<=fertilizer-to-water map:\n).+?(?=\n\n)/m).not_nil![0]
water_to_light_map          = t input.match(/(?<=water-to-light map:\n).+?(?=\n\n)/m).not_nil![0]
light_to_temperature_map    = t input.match(/(?<=light-to-temperature map:\n).+?(?=\n\n)/m).not_nil![0]
temperature_to_humidity_map = t input.match(/(?<=temperature-to-humidity map:\n).+?(?=\n\n)/m).not_nil![0]
humidity_to_location_map    = t input.match(/(?<=humidity-to-location map:\n).+?(?=\n\n)/m).not_nil![0]

def t (input : String)
  input.lines.reduce({} of Range(Int64, Int64) => Range(Int64, Int64)) do |acc, i|
    dst_start, src_start, len = i.split.map(&.to_i64)
    acc[src_start...(src_start+len)] = dst_start...(dst_start+len)
    acc
  end
end

def lookup (id : Int64, map)
  map.each do |k, v|
    if k.includes? id
      return v.begin + (id - k.begin)
    end
  end
  id
end

def full_lookup (id, arr_maps)
  r = id
  arr_maps.each do |map|
    r = lookup(r, map)
  end
  r
end

maps = [
  seed_to_soil_map,
  soil_to_fertilizer_map,
  fertilizer_to_water_map,
  water_to_light_map,
  light_to_temperature_map,
  temperature_to_humidity_map,
  humidity_to_location_map
]
puts "Part 1: #{seeds.map{|s| full_lookup(s, maps)}.min}"

seed_ranges = [] of Range(Int64, Int64)
seeds.each_slice(2) do |r|
  seed_ranges << (r[0]...(r[0]+r[1]))
end

min = Int64::MAX
seed_ranges.each do |r|
  puts "searching #{r}"
  r.each do |s|
    v = full_lookup s, maps
    min = v if v < min
  end
end
puts "Part 2: #{min}"
