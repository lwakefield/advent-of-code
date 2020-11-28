module Nodes
	class DAGNode(T)
		getter children : Array(DAGNode(T))
		getter parent : DAGNode(T) | Nil
		getter value : T

		def initialize (@value : T)
			@children = [] of DAGNode(T)
		end

		def << (child : DAGNode(T))
			@children << child
			child.parent = self
		end

		protected def parent= (p : Node | Nil)
			@parent = p
		end

		def path_to_root
			return [ self ] if @parent.nil?
			return @parent.not_nil!.path_to_root + [ self ]
		end

		def dfs (&block)
			yield self
			@children.each do |child|
				child.dfs &block
			end
		end

		def bfs (&block)
			queue = [self]
			until queue.empty?
				curr = queue.shift
				yield curr
				queue += curr.children
			end
		end
	end

	class SimpleNode(T)
		getter siblings : Array(SimpleNode(T))
		getter value : T

		def initialize (@value : T)
			@siblings = [] of SimpleNode(T)
		end

		def << (sibling : SimpleNode(T))
			@siblings << sibling
			sibling.siblings << self
		end

		protected def << (other)
			@siblings << other
		end

		def dfs (&block)
			queue = [self]
			visited = Set(SimpleNode).new
			until queue.empty?
				curr = queue.pop

				next if visited.includes? curr
				yield curr
				visited.add curr

				curr.each do |child|
					queue << child unless visited.includes? child
				end
			end
		end

		def bfs (&block)
			queue = [self]
			visited = Set(SimpleNode).new
			until queue.empty?
				curr = queue.shift

				next if visited.includes? curr
				yield curr
				visited.add curr

				curr.each do |child|
					queue << child unless visited.includes? child
				end
			end
		end
	end

	class Node(ET,VT)
		getter edges : Array(Edge(ET,VT))
		getter value : VT

		def initialize (@value : VT)
			@edges = [] of Edge(ET,VT)
		end

		def  << (edge : Edge(ET,VT))
			@edges << edge
		end

		def nodes
			@edges.map do |edge|
				edge.nodes[1] if edge.nodes[0] == self
				edge.nodes[0] if edge.nodes[1] == self
			end
		end
	end

	class Edge(ET,VT)
		getter value : ET
		getter nodes : Tuple(Node(ET,VT)) # order is intended to not matter

		def initialize (@value : ET, a : Node(ET,VT), b : Node(ET,VT))
			@nodes = {a, b}
		end
	end
end
