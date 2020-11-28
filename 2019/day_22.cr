require "big"

instructions = File.read(ARGV[0]).lines.reject(&.strip.empty?)

if ARGV.includes? "--solve=1"
	deck = (0...10007).to_a

	instructions.each do |instr|
		deck = case instr
		       when /deal into new stack/
			       deck.reverse
		       when /cut/
			       offset = instr.match(/-?\d+/).not_nil![0].to_i
			       deck[offset...] + deck[...offset]
		       when /deal with increment/
			       increment = instr.match(/\d+/).not_nil![0].to_i
			       new_deck = deck.clone
			       count = 0
			       until deck.empty?
				       new_deck[count % new_deck.size] = deck.shift
				       count += increment
			       end
			       new_deck
		       else
			       raise "unknown instruction #{instr}"
		       end
		# puts instr, deck
	end

	puts deck.index(2019)

elsif ARGV.includes? "--solve=2"
	# see https://www.reddit.com/r/adventofcode/comments/ee0rqi/2019_day_22_solutions/fbnkaju/
	# this is a straight rip

	cards   = 119315717514047.to_i128
	repeats = 101741582076661.to_i128
	inv = ->(x : Int128) { ( x ** (cards - 2)) % cards }
	# get = ->(i : BigInt) { (offset + i * increment) % cards }

	increment_mul = 1.to_i128
	offset_diff = 0.to_i128

	instructions.each do |instr|
		case instr
		when /deal into new stack/
			increment_mul *= -1
			increment_mul %= cards
			offset_diff += increment_mul
			offset_diff %= cards
		when /cut/
			val = instr.match(/-?\d+/).not_nil![0].to_i64.to_i128
			offset_diff += val * increment_mul
			offset_diff %= cards
		when /deal with increment/
			val = instr.match(/\d+/).not_nil![0].to_i64.to_i128
			increment_mul *= modinv(val, cards)
			increment_mul %= cards
		else
			raise "unknown instruction #{instr}"
		end
	end

	increment = pow(increment_mul, 101741582076661.to_i128, cards).to_big_i
	offset = (offset_diff * (1.to_i128 - increment)).to_big_i
	offset *= modinv(((1.to_i128 - increment_mul) % cards).to_i128, cards).to_big_i
	offset %= cards

	puts offset + 2020 * increment % cards

end

def modinv (a : Int128, base : Int128): Int128
	return 0.to_i128 if base == 1

	orig = base
	x = 1.to_i128
	y = 0.to_i128

	while a > 1
		q = a // base

		tmp = base
		base = a % base
		a = tmp
		tmp = y
		y = x - q * y
		x = tmp
	end

	if x < 0
		x + orig
	else
		x
	end
end

def pow (a : Int128, b : Int128, n : Int128): Int128
	r = 1.to_i128
	while b > 0
		if b.odd?
			r *= a
			r %= n
		end
		b = b // 2
		a *= a
		a %= n
	end
	r
end
