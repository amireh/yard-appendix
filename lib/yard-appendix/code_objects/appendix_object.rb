require 'yard/code_objects/base'

module YARD
  module CodeObjects
    
    # An object that is spawned by the @!appendix directive.
    #
    # @see YARD::Tags::AppendixDirective
    class AppendixObject < Base
      def type; :appendix end
      def title; "Appendix: #{name}" end
      def path; ".#{type}.#{namespace && namespace.path}.#{name}" end
      def to_s; "#{name}-appendix" end
      
      # def link_keyword
      #   'Appendix:'
      # end
      
      # def linked_by?(text)
      #   @name.to_s == text.to_s
      # end
      
    end # AppendixObject
  end # CodeObjects
end # YARD