require 'yard/handlers/ruby/comment_handler'

module YARD
  module Handlers
    module Ruby
      # Tracks every namespace defining statement and registers
      # it with the NamespaceResolver.
      #
      # @see YARD::AppendixPlugin::NamespaceResolver
      class AppendixHandler < CommentHandler
        handles :class, :module
        
        def initialize(*args)
          super(*args)
          
          globals.resolver ||= YARD::AppendixPlugin::NamespaceResolver.new
        end
        
        def process
          globals.resolver.register_namespace(statement, namespace)
        end  
      end # AppendixHandler
    end # Ruby
  end # Handlers
end # YARD