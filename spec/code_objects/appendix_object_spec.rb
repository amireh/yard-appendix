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

include CodeObjects

describe YARD::CodeObjects::AppendixObject do
  before { Registry.clear }

  it "should create an appendix object" do
    o1 = AppendixObject.new(:root, 'Zoo')
  end

  it "should respect uniqueness of appendix titles in scope" do
    # root scope, same titles:
    o1 = AppendixObject.new(:root, 'Zoo')
    o2 = AppendixObject.new(:root, 'Zoo')
    o1.should == o2

    # root scope, different titles:
    o3 = AppendixObject.new(:root, 'Monkeys')
    o4 = AppendixObject.new(:root, 'Parrots')
    o3.should_not == o4

    # custom scope:
    YARD.parse_string <<-'eof'
      module TheZoo
        module ParrotZone
        end
      end
    eof

    # same scope, same title:
    o1 = AppendixObject.new(Registry.at('TheZoo'), 'Animals')
    o2 = AppendixObject.new(Registry.at('TheZoo'), 'Animals')
    o1.should == o2

    # same scope, different title:
    o1 = AppendixObject.new(Registry.at('TheZoo'), 'Monkeys')
    o2 = AppendixObject.new(Registry.at('TheZoo'), 'Parrots')
    o1.should_not == o2

    # same title, different scope:
    o3 = AppendixObject.new(Registry.at('TheZoo.ParrotZone'), 'Monkeys')
    o1.should_not == o3
  end

end