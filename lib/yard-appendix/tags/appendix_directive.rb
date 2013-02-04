require 'yard/tags/directives'

module YARD
  module Tags
    
    # Defines a @!appendix directive that allows writing Appendix
    # entries which will be attached to the end of the namespace's
    # output, similar to appendixes in books or documents.
    #
    # @example Appendix definition syntax
    #  module SomeModule
    #    # @!appendix Title
    #    #
    #    # Appendix body.
    #  end
    #
    # @note When defining an appendix entry, there's no need to
    #  prefix its name with 'Appendix: ' as that is automatically
    #  done for you.
    #
    # @example Defining an appendix titled 'API Response Codes'
    #
    #  class BananaAPIController
    #    # Explain why one would want a fried banana, what it would do
    #    # to their health and self-esteem, and any side-effects one
    #    # would enjoy.
    #    #
    #    # @see Appendix: API Response Codes
    #    def serve_fried_bananas
    #    end
    #  
    #    # @!appendix API Response Codes
    #    # 
    #    # The following map explains the HTTP response codes returned 
    #    # by our servers and how you should treat them:
    #    #
    #    #   1. 200 -> a banana is available
    #    #   1. 403 -> that banana is super exclusive
    #    #   1. 404 -> no such banana, verify the ID 
    #  end
    #
    # You can also reference the appendix identified by `Title` in
    # other parts of your namespace documentation strings by using
    # the @see tag. See the "See Also" link for more info about
    # referencing appendices.
    #
    # @see YARD::AppendixPlugin::AppendixLinker
    class AppendixDirective < Directive
      
      def statement;    handler.statement; end
      def namespace;    handler.namespace; end
      def resolver;     handler.globals.resolver; end
      
      def call
        # no resolver? then use the handler's namespace
        comment_ns = handler.namespace
        
        if resolver
          comment_ns = resolver.namespace_for(statement, namespace)
          log.debug "yard-appendix: appendix #{tag.name} will be enclosed under #{comment_ns}"
        end

        appendix = CodeObjects::AppendixObject.new(comment_ns, tag.name)
        handler.register_docstring appendix, tag.text
        handler.register_file_info appendix
      end
    end
  end
end