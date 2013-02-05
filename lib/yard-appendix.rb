#
# Copyright (c) 2011 Ahmad Amireh <ahmad@amireh.net>
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

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'yard'
require 'yard-appendix/version'
require 'yard-appendix/namespace_resolver'
require 'yard-appendix/code_objects/appendix_object'
require 'yard-appendix/tags/appendix_directive'
require 'yard-appendix/handlers/appendix_handler'
require 'yard-appendix/templates/helpers/html_helper'

module YARD
  module AppendixPlugin
    ROOT          = File.dirname(__FILE__)
    TEMPLATE_PATH = File.join(%W[#{ROOT} .. templates])
  end

  module Templates
    Engine.register_template_path YARD::AppendixPlugin::TEMPLATE_PATH
  end

  module Tags
    Library.define_directive(:appendix, :with_title_and_text, AppendixDirective)
  end
end