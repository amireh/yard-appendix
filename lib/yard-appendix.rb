$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'yard'
require 'yard-appendix/namespace_resolver'
require 'yard-appendix/code_objects/appendix_object'
require 'yard-appendix/tags/appendix_directive'
require 'yard-appendix/handlers/appendix_handler'
require 'yard-appendix/templates/helpers/html_helper'

module YARD
  Templates::Engine.register_template_path File.dirname(__FILE__) + '/../templates'
  Handlers::Ruby::CommentHandler.inherited(Handlers::Ruby::AppendixHandler)
  Tags::Library.define_directive(:appendix, :with_title_and_text, Tags::AppendixDirective)
end