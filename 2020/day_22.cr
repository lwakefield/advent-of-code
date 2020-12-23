def play(alice, bob)
  top_alice, top_bob = alice.shift, bob.shift
  if top_alice > top_bob
    alice << top_alice
    alice << top_bob
  else
    bob << top_bob
    bob << top_alice
  end
end

def play_again(alice, bob)
  previous_rounds = Set(String).new
  until alice.empty? || bob.empty?
    key = "a:#{alice.join(",")}|b:#{bob.join(",")}"
    return "alice" if previous_rounds.includes? key
    previous_rounds.add key

    top_alice, top_bob = alice.shift, bob.shift
    winner = if top_alice <= alice.size && top_bob <= bob.size
               play_again(alice[...top_alice], bob[...top_bob])
             elsif top_alice > top_bob
               "alice"
             else
               "bob"
             end
    if winner == "alice"
      alice << top_alice
      alice << top_bob
    elsif winner == "bob"
      bob << top_bob
      bob << top_alice
    end
  end
  return "alice" if bob.empty?
  return "bob" if alice.empty?

  raise "no winner?"
end

def winner(alice, bob)
  return "alice" if bob.empty?
  return "bob" if alice.empty?
end

def score(cards)
  res = 0
  cards.reverse.each_with_index do |v, i|
    res += v * (i + 1)
  end
  res
end

alice_cards, bob_cards = File.read(ARGV.first? || "./day_22.txt").split("\n\n").map(&.lines)
alice_cards = alice_cards[1..].map(&.to_i)
bob_cards = bob_cards[1..].map(&.to_i)

until winner(alice_cards, bob_cards)
  play(alice_cards, bob_cards)
end
winning_player = winner(alice_cards, bob_cards)
winning_score = if winning_player == "alice"
                  score(alice_cards)
                elsif winning_player == "bob"
                  score(bob_cards)
                end
puts "part 1 winner=#{winning_player} score=#{winning_score}"

alice_cards, bob_cards = File.read(ARGV.first? || "./day_22.txt").split("\n\n").map(&.lines)
alice_cards = alice_cards[1..].map(&.to_i)
bob_cards = bob_cards[1..].map(&.to_i)

winning_player = play_again(alice_cards, bob_cards)
winning_score = if winning_player == "alice"
                  score(alice_cards)
                elsif winning_player == "bob"
                  score(bob_cards)
                  end
puts "alice=#{alice_cards} bob=#{bob_cards}"
puts "part 2 winner=#{winning_player} score=#{winning_score}"
