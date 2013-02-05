require File.join(%W[#{File.dirname(__FILE__)} lib yard-appendix version])

Gem::Specification.new do |s|
  s.name        = 'yard-appendix'
  s.summary     = "A YARD plugin that adds support for Appendix sections."
  s.description = <<-eof
    yard-appendix is a plugin for YARD, the Ruby documentation generation tool,
    that defines a special directive @!appendix for writing appendixes for your
    code documentation, similar to appendixes you find in books.

    Appendix entries can be referenced to by methods and classes in your docs
    using the @see tag and inline-references, just like any other object.
  eof
  s.version     = YARD::AppendixPlugin::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.authors     = ["Ahmad Amireh"]
  s.email       = 'ahmad@instructure.com'
  s.homepage    = 'https://github.com/amireh/yard-appendix'
  s.files       = Dir.glob("{lib,spec,templates}/**/*.rb") +
                  ['LICENSE', 'README.md', '.rspec', __FILE__]
  s.has_rdoc    = 'yard'
  s.license     = 'MIT'
  s.add_dependency('yard', '>= 0.8.0')
  s.add_development_dependency 'rspec'
end
