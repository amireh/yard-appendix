Gem::Specification.new do |s|
  s.name        = 'yard-appendix'
  s.version     = '0.1.0'
  s.summary     = "A YARD plugin that adds support for Appendix sections."
  s.description = "Defines a @!appendix directive that lets you write object-free" <<
                  " documentation which you can link to in your docstrings using" <<
                  " the @see tag."
  s.authors     = ["Ahmad Amireh"]
  s.email       = 'ahmad@amireh.net'
  s.files       = Dir.glob("lib/**/*.rb")
  s.homepage    = 'https://github.com/amireh/yard-appendix'

  s.add_dependency('yard', '>= 0.8.3')
  s.add_development_dependency 'rspec'
end
