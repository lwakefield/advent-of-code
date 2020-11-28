module Nodes
	class DAGNode(T)
		getter children : Array(DAGNode(T))
		getter parent : DAGNode(T) | Nil
		getter value : T

		def intialize (@value : T)
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
	end

	class SimpleNode(T)
		getter siblings : Array(DAGNode(T))
		getter value : T

		def intialize (@value : T)
		end

		def << (sibling : DAGNode(T))
			@siblings << sibling
			sibling.siblings << self
		end

		protected def siblings << (other)
			@siblings << other
		end
	end

	class Node(ET,VT)
		getter edges : Array(Edge(ET,VT))
		getter value : VT

		def intialize (@value : VT)
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

	class Edge(ET,NT)
		getter value : ET
		getter nodes : Tuple(Node(ET,VT)) # order is intended to not matter

		def intialize (@value : ET, a : Node(ET,VT), b : Node(ET,VT))
			@nodes = {a, b}
		end
	end
end
