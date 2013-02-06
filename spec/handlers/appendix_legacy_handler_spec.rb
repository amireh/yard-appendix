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

unless RUBY19

include Handlers::Ruby::Legacy

describe YARD::Handlers::Ruby::Legacy::AppendixHandler do

  before {
    Registry.clear

    class StubHandler < AppendixHandler
      handles AppendixHandler::MATCH

      def self.resolver; @@resolver end
      def process; @@resolver ||= globals.resolver end
    end
  }

  it "should track a namespace statement" do
    YARD.parse_string <<-'eof'
      module SomeModule
        class SomeClass
          # comment in SomeClass
        end

        # comment in SomeModule
      end
    eof

    StubHandler.resolver.namespaces.size.should == 2
    StubHandler.resolver.namespaces["SomeModule"].should == "SomeModule"
    StubHandler.resolver.namespaces["SomeClass"].should == "SomeModule::SomeClass"
  end

  it "should locate an enclosing ns for a comment" do
    class StubCommentHandler < Handlers::Ruby::Legacy::Base
      handles TkCOMMENT
      namespace_only

      class << self
        def comments; @@comments end
      end

      def process
        @@comments ||= []
        @@comments << [ statement.tokens.to_s, namespace ]
      end
    end


    YARD.parse_string <<-'eof'
      module SomeModule
        class SomeClass
          def f() end
          # comment in SomeClass
          
          # another comment in SomeClass
        end

        # comment in SomeModule
      end # should be ignored

      # comment in :root
    eof

    comments = StubCommentHandler.comments
    comments.size.should == 4

    resolver = StubHandler.resolver
    resolver.namespaces.size.should == 2

    resolver.
      namespace_for(
        comments[0][0],
        comments[0][1]).
      should == Registry.at('SomeModule::SomeClass')
    
    resolver.
      namespace_for(
        comments[1][0],
        comments[1][1]).
      should == Registry.at('SomeModule::SomeClass')

    resolver.
      namespace_for(
        comments[2][0],
        comments[2][1]).
      should == Registry.at('SomeModule')

    resolver.
      namespace_for(
        comments[3][0],
        comments[3][1]).
      should == Registry.root

  end

end
end