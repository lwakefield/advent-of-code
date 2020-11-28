def test_password (to_test : String)
	return false if to_test.size != 6
	return false if to_test.chars.sort != to_test.chars
	return false if to_test.scan(/(\d)\1+/).reject do |match|
		match.[0].size != 2
	end.size == 0

	true
end

left, right = ARGV[0].split '-'
candidates = [] of String

(left.to_i32..right.to_i32).each do |p|
	candidates << p.to_s if test_password(p.to_s)
end

candidates.each do |p|
	puts p
end
