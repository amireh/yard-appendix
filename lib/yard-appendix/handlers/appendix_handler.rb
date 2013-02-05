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

      CommentHandler.inherited(AppendixHandler)
    end # Ruby
  end # Handlers
end # YARD