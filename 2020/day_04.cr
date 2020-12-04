passports = File.read("day_04.txt").split("\n\n")

def is_valid_part_one(passport)
  byr = passport.match /(?<=byr:)\S+/
  iyr = passport.match /(?<=iyr:)\S+/
  eyr = passport.match /(?<=eyr:)\S+/
  hgt = passport.match /(?<=hgt:)\S+/
  hcl = passport.match /(?<=hcl:)\S+/
  ecl = passport.match /(?<=ecl:)\S+/
  pid = passport.match /(?<=pid:)\S+/
  cid = passport.match /(?<=cid:)\S+/

  byr && iyr && eyr && hgt && hcl && ecl && pid
end

def is_valid_part_two(passport)
  byr = passport.match(/(?<=byr:)\S+/)
  iyr = passport.match(/(?<=iyr:)\S+/)
  eyr = passport.match(/(?<=eyr:)\S+/)
  hgt = passport.match(/(?<=hgt:)\S+/)
  hcl = passport.match(/(?<=hcl:)\S+/)
  ecl = passport.match(/(?<=ecl:)\S+/)
  pid = passport.match(/(?<=pid:)\S+/)
  cid = passport.match(/(?<=cid:)\S+/)

  unless [byr, iyr, eyr, hgt, hcl, ecl, pid].all?
    # puts "invalid: #{passport}"
    return false
  end

  byr = byr.not_nil![0]
  iyr = iyr.not_nil![0]
  eyr = eyr.not_nil![0]
  hgt = hgt.not_nil![0]
  hcl = hcl.not_nil![0]
  ecl = ecl.not_nil![0]
  pid = pid.not_nil![0]

  valid_byr = (1920..2002).includes? byr.to_i
  valid_iyr = (2010..2020).includes? iyr.to_i
  valid_eyr = (2020..2030).includes? eyr.to_i
  valid_hgt = if hgt.includes? "cm"
                (150..193).includes? hgt.rstrip("cm").to_i
              elsif hgt.includes? "in"
                (59..76).includes? hgt.rstrip("in").to_i
              else
                false
              end
  valid_hcl = hcl.match(/^#[0-9a-f]{6}$/).nil? == false
  valid_ecl = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].includes? ecl
  valid_pid = pid.match(/^[0-9]{9}$/).nil? == false

  if [valid_byr, valid_iyr, valid_eyr, valid_hgt, valid_hcl, valid_ecl, valid_pid].all?
    true
  else
    # puts "invalid: #{passport}"
    # puts [valid_byr, valid_iyr, valid_eyr, valid_hgt, valid_hcl, valid_ecl, valid_pid]
    # puts ""
    false
  end
end

puts passports.select { |p| is_valid_part_one p }.size
puts passports.select { |p| is_valid_part_two p }.size
