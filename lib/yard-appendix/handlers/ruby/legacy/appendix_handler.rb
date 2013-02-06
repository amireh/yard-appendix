require 'yard/handlers/ruby/legacy/base'


module YARD
  module Handlers
    module Ruby
      module Legacy
        class AppendixHandler < Base
          MATCH = /\A(class|module)\s+([\w|_])+\s*[<|;|\n]?/
          handles MATCH
          
          def initialize(*args)
            super(*args)

            globals.resolver ||= YARD::AppendixPlugin::NamespaceResolver.new
          end

          def process
            ns = statement.tokens.to_s.split(/\s+/).last
            globals.resolver.register_namespace(ns, namespace)
          end
        end
      end
    end
  end
end