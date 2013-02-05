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

describe YARD::AppendixPlugin::AppendixLinker do
  include YARD::Templates::Helpers::BaseHelper
  include YARD::Templates::Helpers::HtmlHelper
  include YARD::Templates::Helpers::MethodHelper

  before {
    Registry.clear
  }

  it "should linkify an appendix object" do
    linkify('Appendix: Booyah').should == 'Appendix: Booyah'


    YARD.parse_string <<-'eof'
      module TheAnswer
        # @!appendix 42
        #
        # Vroom vroom.
      end
    eof

    Registry.all(:appendix).count.should == 1

    stub!(:serializer).and_return(Serializers::FileSystemSerializer.new)
    stub!(:object).and_return(Registry.all(:appendix).first)

    linkify('Appendix:','42').should match(%r{<a href="#42-appendix".*>Appendix: 42</a>})
  end

  it "should linkify an appendix with any title" do
    YARD.parse_string <<-'eof'
      module TheAnswer
        # @!appendix Life, the Universe, and Everything
        #
        # Vroom vroom.
      end
    eof

    Registry.all(:appendix).count.should == 1

    stub!(:serializer).and_return(Serializers::FileSystemSerializer.new)
    stub!(:object).and_return(Registry.all(:appendix).first)

    linkify('Appendix:','Life, the Universe, and Everything').should match(
      %r{<a href="#Life%2C\+the\+Universe%2C\+and\+Everything\-appendix".*>Appendix: Life, the Universe, and Everything</a>})
  end

end