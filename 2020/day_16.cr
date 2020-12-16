rules, my_ticket, nearby_tickets = File.read("day_16.txt").split("\n\n")

rules = rules.lines.reduce({} of String => Array(Range(Int32, Int32))) do |acc, curr|
  m = curr.match(/(?<name>.+): (?<min_1>\d+)-(?<max_1>\d+) or (?<min_2>\d+)-(?<max_2>\d+)/).not_nil!
  acc[m["name"]] = [
    (m["min_1"].to_i..m["max_1"].to_i),
    (m["min_2"].to_i..m["max_2"].to_i),
  ]
  acc
end

def get_invalid_fields(ticket : Array(Int32), rules)
  ticket.select do |v|
    matching_rule = rules.values.flatten.find do |range|
      range.includes? v
    end
    matching_rule.nil?
  end
end

my_ticket = my_ticket.lines[1].split(",").map(&.to_i)
nearby_tickets = nearby_tickets.lines[1..].map { |l| l.split(",").map(&.to_i) }

invalid_values = nearby_tickets.map { |t| get_invalid_fields(t, rules) }.flatten
puts "part 1: #{invalid_values.sum}"

valid_tickets = nearby_tickets.select { |t| get_invalid_fields(t, rules).empty? }

rule_matches = {} of String => Array(Int32)

rules.size.times do |idx|
  rules.each do |k, rule|
    is_match = valid_tickets.map { |t| t[idx] }.map { |v| rule[0].includes?(v) || rule[1].includes?(v) }.all?
    rule_matches[k] ||= [] of Int32
    rule_matches[k] << idx if is_match
  end
end

# rule_matches.to_a.sort do |a, b|
#     b[1] <=> a[1]
# end.each do |k, v|
#     puts k, v
# end

# done by hand...
rules_to_field = {
  "duration"           => 18,
  "row"                => 7,
  "train"              => 6,
  "arrival platform"   => 10,
  "seat"               => 16,
  "departure location" => 19,
  "arrival station"    => 11,
  "departure date"     => 0,
  "departure track"    => 9,
  "departure platform" => 5,
  "departure time"     => 1,
  "departure station"  => 12,
  "class"              => 3,
  "arrival track"      => 14,
  "zone"               => 13,
  "route"              => 2,
  "arrival location"   => 17,
  "type"               => 8,
  "price"              => 4,
  "wagon"              => 15,
}

puts "part 2: #{rules_to_field.keys.select(&.starts_with? "departure").map do |f|
                  my_ticket[rules_to_field[f]].to_u64
                end.product}"
