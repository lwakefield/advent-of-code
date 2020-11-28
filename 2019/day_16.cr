def fft (input : String, num_phases : Int64)
	digits = input.chars.map(&.to_i64)
	base_pattern : Array(Int64) = [0i64, 1i64, 0i64, -1i64]

	num_phases.times do |n|
		puts "phase #{n + 1}"
		next_digits = digits.map_with_index do |digit, index|
			pattern = base_pattern.reduce([] of Int64) do |acc, v|
				acc + [v] * (index + 1)
			end.rotate(1)
			pattern *= ( (digits.size.to_f / pattern.size).ceil.to_i )
			pattern = pattern[0...digits.size]

			digits.zip(pattern).map do |left, right|
				left * right
			end.sum.abs % 10
		end
		digits = next_digits
	end

	digits.map(&.to_s).join
end

if ARGV.includes? "--solve=1"
	puts fft(STDIN.gets_to_end.strip, ARGV[0].to_i64)
elsif ARGV.includes? "--solve=2"
	signal = (STDIN.gets_to_end.strip * 10000).chars.map(&.to_i)
	offset = signal[0...7].join.to_i32

	# it appears that offset is alway > n/2
	# once offset > n/2 the pattern looks like 00001111
	# such that for the val at offset is a sum of the backhalf.abs.mod10

	100.times do
		sum = signal[offset...signal.size].sum
		(offset...signal.size).each do |index|
			num = signal[index]
			signal[index] = sum.abs % 10
			sum -= num
		end
	end
	puts signal[offset ... offset + 8].join
end
