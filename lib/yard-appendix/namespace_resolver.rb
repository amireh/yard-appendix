module YARD
  module AppendixPlugin
    
    # This class is a necessary hack for locating the namespaces in which
    # comments that are not tied to any CodeObjects were defined.
    #
    # The issue has been reported as a bug in Ripper and until it is solved,
    # this is required to work around it.
    class NamespaceResolver
      attr_reader :namespaces
      
      def initialize()
        @namespaces ||= {}
        
        super()
      end
      
      # Tracks the namespace the namespace-defining statement (such as class or module)
      # was registered in. This registry is used to map between free comment statements
      # and the namespace they're actually defined in.
      #
      # @param [Parser::Ruby::ClassNode, Parser::Ruby::ModuleNode] statement
      #  the namespace defining statement
      # @param [CodeObjects::NamespaceObject] ns the namespace object the YARD handler processor
      #  was tracking when the statement was parsed
      #
      # @return [void]
      #
      # @see namespace_for
      #
      # @note
      #  Internally called by the AppendixHandler whenever a new namespace object
      #  is encountered.
      def register_namespace(statement, ns)
        klass_name = path_from_ast(statement, ns)
        
        # already registered?
        return if @namespaces[klass_name]
        
        klass_path = path_from_ast(statement, ns, true)
        
        log.debug "yard-appendix: registering path for namespace '#{klass_name}' => #{klass_path}"
        
        @namespaces[klass_name] = klass_path
      end  
      
      # Attempts to locate the enclosing namespace for the given
      # statement. This is useful only for comment statements which
      # are parsed by Ripper in a strange non-linear fashion that does not
      # correlate with the namespace they're defined in.
      #
      # @param [YARD::Parser::Ruby::AstNode] statement the enclosed CommentNode
      #  (or any other type, really)
      # @param [YARD::CodeObjects::NamespaceObject] ns the handler's current namespace
      # @return [CodeObjects::NamespaceObject] the enclosing namespace object
      def namespace_for(statement, ns)
        YARD::Registry.at(locate_enclosing_ns(statement, ns))
      end
      
      protected
      
      # Attempts to locate the enclosing namespace for the given
      # statement. This is useful only for comment statements which
      # are parsed by Ripper in a strange non-linear fashion that does not
      # correlate with the namespace they're defined in.
      #
      # @param [YARD::Parser::Ruby::AstNode] statement the enclosed CommentNode
      #  (or any other type, really)
      # @param [YARD::CodeObjects::NamespaceObject] ns the handler's current namespace
      # @return [String] a Registry path to the enclosing namespace object
      #
      # @note
      #  You shouldn't need to use this directly. Use #namespace_for instead.
      #
      # @see #namespace_for
      def locate_enclosing_ns(statement, ns)
        
        unless ns || CodeObjects::NamespaceObject === ns || String === ns
          raise ArgumentError.new "A valid NamespaceObject must be passed."
        end
        
        if ns.is_a?(String)
          ns = YARD::Registry.at(ns)
        end
        
        lines_to_namespaces = {}
        statement.parent.traverse { |ast|
          next unless [:module, :class].include?(ast.type)

          if ast.line_range.include?(statement.line)
            lines_to_namespaces[ast.line] = ast        
          end
        }
        
        closest = {}
        lines_to_namespaces.each_pair { |line, ast|
          distance = statement.line - line
          if closest.empty? || distance < closest[:distance]
            closest = { node: ast, distance: distance }
          end
        }
        
        path_to(closest[:node], ns)
      end
        
      def path_from_ast(node, ns, fully_qualified = false)
        path = ''
        
        if fully_qualified
          unless ns.to_s.empty? || ns.to_s == 'root'
            path = ns.to_s + '::'
          end
        end
        
        path += case node.type
        when :class;  node.class_name.path.first
        when :module; node.module_name.path.first
        end
      end
      
      def path_to(ast, ns)
        (ast && @namespaces[path_from_ast(ast, ns)]) || ns.to_s
      end
        
    end
  end
end