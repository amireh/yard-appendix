require 'yard/templates/helpers/html_helper'

module YARD
  module AppendixPlugin
    module AppendixLinker
      
      # Handles reference links to Appendix objects in @see tags
      # by printing out their readable titles in the anchor text and tooltip. 
      #
      # Delegates to YARD::Templates::Helpers::HtmlHelper#linkify if
      # the @see tag syntax does not qualify as an appendix one.
      #
      # @example Referencing appendix objects:
      #
      #  # Some method description.
      #  # ...
      #  # @see Appendix: Bananas
      #  def some_method()
      #  end
      #
      # Note that the syntax expected is `@see Appendix: APPENDIX_NAME` where
      # only the `APPENDIX_NAME` is variable.
      #
      # @note
      #  Appendix links will be resolved only within the namespace they're defined in (class or module).
      #  
      def linkify(link, *args)
        if link == 'Appendix:' && !args.empty?
          return link_appendix(args.first)
        end
        
        super(link, *args)
      end
      
      def link_appendix(title)
        appendix = YARD::Registry.at(".appendix.#{object.namespace.path}.#{title}")
        unless appendix.nil?
          link = url_for(appendix, nil, true)
          link = link ? link_url(link, appendix.title, :title => h(appendix.title)) : appendix.title
          
          return "<span class='object_link'>#{link}</span>"
        end    
      end
    end
  end
end

module YARD
  module Templates
    module Helpers
      module HtmlHelper
        include YARD::AppendixPlugin::AppendixLinker
      end
    end
  end
end

# module YARD::Templates::Helpers::HtmlHelper
#   alias_method :old_link_object, :link_object # yeah...
#
#   def link_object(obj, otitle = nil, anchor = nil, relative = true)
#     if obj && obj.is_a?(String) && obj == 'Appendix:'
#       appendix = object.namespace.children.select { |o| o.type == :appendix && o.title == "Appendix: #{otitle}" }.first
#
#       unless appendix.nil?
#         link = url_for(appendix, anchor, relative)
#         link = link ? link_url(link, appendix.title, :title => h(appendix.title)) : appendix.title
#
#         return "<span class='object_link'>#{link}</span>"
#       end
#     end
#
#     return old_link_object(obj, otitle, anchor, relative)
#   end
#
# end