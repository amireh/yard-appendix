# yard-appendix

[![Build Status](https://travis-ci.org/amireh/yard-appendix.png)](https://travis-ci.org/amireh/yard-appendix)

A YARD plugin that adds support for Appendix sections like ones you find in books and papers. Appendix entries provide you with a very convenient place to write supplementary documentation, references, or advanced-usage content, that would otherwise clutter up (or even seem unrelated) a certain method or class inline-documentation.

## Usage

The plugin defines a `@!appendix` directive that lets you write the appendix entry with a title. You can link to in your docstrings using the explicit `@see` tag, or an inline reference as in: `(see {path to appendix})`.

**Defining appendices**

```ruby
class SomeClass
  # your methods here
  def foo()
  end
  
  # @!appendix Title
  #
  # Appendix body goes here.
end
```

**Referencing appendix entries**

Referencing appendices is done by prefixing the appendix title with `Appendix: `. To reference the appendix defined above with the title `Title`:

```ruby
class SomeClass
  # foo() brief
  #
  # Inline reference: (see {Appendix: Title})
  #
  # Explicit reference:
  #
  # @see Appendix: Title
  def foo()
  end
  
  # ...
end
```

**Note**: you can define the appendix entry wherever you want; they can be attached to a node or "free", at the bottom of the module or class definition.

## Example

Let's say you're writing an API controller that serves and manages Bananas in your warehouse. One of the methods is called `serve_fried_bananas()` and you want to provide some background about fried bananas that:

1. is too long and would clutter up the rest of the method's documentation
2. contains supplementary content that only users with specific uses of the method need to know about

We will instead define an appendix titled `Fried Bananas`, and in our method's docstring we will reference that appendix for the user to check out.

```ruby
module FruitAPI
  
  class BananaController
    # Explain why one would want a fried banana, what it would do
    # to their health and self-esteem, and any side-effects one
    # would enjoy.
    #
    # @see Appendix: Fried Bananas
    def serve_fried_bananas
    end

    # @!appendix Fried Bananas
    # 
    # This entry will be displayed at the bottom of the class'
    # documentation page, under a separate section aptly named
    # 'Appendixes'.
    #
    # You can use tags and directives here just like you would in
    # any other docstring.
    #
    # @example A fried banana in JSON
    #   {
    #     "id": 1,
    #     "type": "fried",
    #     "frying_level": "atomic"
    #   }
    #
    # You can also reference other appendices: {Appendix: Fruit}
    
    # @!appendix Fruit
    #
    # ...
  end
  
end
```

### Other stuff

You can run the specs using RSpec:

```bash
cd /path/to/yard-appendix; rspec spec/
```

And you can generate the docs using YARD:

```bash
cd /path/to/yard-appendix; yardoc
```

## License
Copyright (c) 2012-2013 Ahmad Amireh

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.