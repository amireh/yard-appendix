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

        log.info "yard-appendix: appendix #{tag.name} has been registered under #{comment_ns.name}"
        appendix = CodeObjects::AppendixObject.new(comment_ns, tag.name)
        handler.register_docstring appendix, tag.text
        handler.register_file_info appendix
      end
    end
  end
end