#
# Copyright (c) 2013 Instructure, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

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
          if res = link_appendix(args.first)
            return res
          end
        end

        super(link, *args)
      end

      def link_appendix(in_title)
        appendix, title = nil, in_title.to_s.strip.to_sym
        ns = nil # used for reporting in case we couldn't locate it

        if object
          # try in the object scope
          ns = object
          appendix = YARD::Registry.at(".appendix.#{object.path}.#{title}")

          # try in the object's namespace scope
          if appendix.nil? && object.respond_to?(:namespace)
            ns = object.namespace
            appendix = YARD::Registry.at(".appendix.#{object.namespace.path}.#{title}")
          end
        # else
          # this shouldn't happen (use stub!(:object) in specs)
          # appendix = YARD::Registry.all(:appendix).select { |a| a.name == title }.first
        end

        unless appendix.nil?
          link = url_for(appendix, nil, true)
          link = link ? link_url(link, appendix.title, :title => h(appendix.title)) : appendix.title

          return "<span class='object_link'>#{link}</span>"
        end

        log.warn %Q[unable to locate referenced appendix '#{title}'#{ns ? " in namespace " + ns.name.to_s : ''}]
        nil
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