recipes = {} of Set(String) => Set(String)
File.each_line(ARGV.first? || "day_21.txt") do |line|
    ingredients, allergens = line.split("(contains")

    ingredients = ingredients.strip.split(' ')
    allergens = allergens.strip(')').strip.split(", ")
    recipes[ingredients.to_set] = allergens.to_set
end

all_allergens = recipes.values.map(&.to_a).flatten.to_set
found_allergens = Set(String).new
ingredient_to_allergen = {} of String => String

until ingredient_to_allergen.size == all_allergens.size
    success = false
    all_allergens.each do |allergen|
        ingredients_sets = recipes.select {|k,v| v.includes? allergen }.keys
        common = ingredients_sets.reduce(ingredients_sets.first.to_set) do |acc, curr|
            acc & curr
        end - found_allergens

        if common.size == 1
            success = true
            found_allergens.add common.first
            ingredient_to_allergen[common.first] = allergen
        end
    end

    raise "could not find allergen" unless success
end

puts ingredient_to_allergen
all_ingredients = recipes.keys.map(&.to_a).flatten.to_set
non_allergens = all_ingredients - found_allergens

non_allergen_count = 0
non_allergens.each do |ing|
    recipes.keys.each do |ingredients|
        non_allergen_count += 1 if ingredients.includes? ing
    end
end
puts "part 1: #{non_allergen_count}"

part_2_res = ingredient_to_allergen.to_a.sort do |a, b|
    a[1] <=> b[1]
end.map(&.first).join(",")
puts "part 2: #{part_2_res}"
