class Node
    property val
    property children
    def initialize(@val = "", @children = [] of Node) end
end

class NodeCache
    class_property rules = {} of String => Node
    def self.[] (id)
        @@rules[id] ||= Node.new
        @@rules[id]
    end
end

rule_lines, input = File.read("./day_19.txt").split("\n\n").map(&.lines)

rule_lines.each do |line|
    id, rest = line.split(':')
    rest = rest.strip

    if rest.starts_with? '"'
        NodeCache[id].val = rest.strip('"')
    else
        rule = NodeCache[id]
        rule.val = "OR:#{id}"
        rest.split(" | ").map(&.split(' ')).each do |parts|
            node = Node.new("CONCAT")
            parts.each do |p|
                node.children << NodeCache[p]
            end
            rule.children << node
        end
    end
end

def to_rgx(rule, overrides = {} of Node => String)
    Regex.new('^' + _to_rgx(rule, overrides) + '$')
end
def _to_rgx (rule, overrides = {} of Node => String) : String
    if overrides[rule]?
        overrides[rule]
    elsif rule.val.starts_with? "CONCAT"
        rule.children.map do |child|
            _to_rgx(child, overrides)
        end.join
    elsif rule.val.starts_with? "OR"
        "(" + rule.children.map do |child|
            _to_rgx(child, overrides)
        end.join('|') + ")"
    else
        rule.val
    end
end


rgx = to_rgx(NodeCache["0"])
puts("part 1: #{input.count do |line|
    line.matches?(rgx)
end}")

def visit (node)
    to_visit = [node]
    until to_visit.empty?
        n = to_visit.pop
        yield n
        to_visit += n.children
    end
end

overrides = { } of Node => String
x = _to_rgx(NodeCache["42"])
y = _to_rgx(NodeCache["31"])
overrides[NodeCache["8"]] = "(#{x})+"
# lol
overrides[NodeCache["11"]] = "(#{x}#{y}|#{x*2}#{y*2}|#{x*3}#{y*3}|#{x*4}#{y*4}|#{x*5}#{y*5})"

rgx = to_rgx(NodeCache["0"], overrides)
puts("part 2: #{input.count do |line|
    line.matches?(rgx)
end}")
