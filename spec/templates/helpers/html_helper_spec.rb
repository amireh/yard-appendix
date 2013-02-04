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