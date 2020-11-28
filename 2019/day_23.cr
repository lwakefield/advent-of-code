require "./intcode.cr"

input_program = File.read(ARGV[0])
	.split(',')
	.map(&.strip)
	.map(&.to_i64)

nics = (0...50).map do |n|
	program = Program.new(input_program.clone) # CLONE IT
	program.write [n, -1]
	program
end

last_nat_packet_sent = nil
nat_packet = {-1, -1}
loop do
	nics.each_with_index do |nic, index|
		nic.write -1 if nic.input.empty?
		nic.run

		if addr = nic.read?
			x = nic.read
			y = nic.read

			puts({ addr, x, y })
			if addr == 255
				nat_packet = {x, y}
			else
				nics[addr].write [x, y]
			end
		end
	end

	if nics.all?(&.input.empty?)
		puts "NAT: #{nat_packet}"
		nics[0].write nat_packet
		if last_nat_packet_sent == nat_packet
			exit 0
		end
		last_nat_packet_sent = nat_packet
	end
end
