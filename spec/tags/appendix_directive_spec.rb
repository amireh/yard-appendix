include YARD::Tags

describe YARD::Tags::AppendixDirective do
  before { Registry.clear }
  
  it "should build an AppendixObject" do
    YARD.parse_string <<-'eof'
      module TheQuestion
        module TheAnswer
          # @!appendix 42
        end
        
        # @!appendix Life, the Universe, and Everything
      end
    eof
    
    appendixes = Registry.all(:appendix)
    appendixes.count.should == 2
    appendixes[0].namespace.should == Registry.at("TheQuestion::TheAnswer")
    appendixes[1].namespace.should == Registry.at("TheQuestion")
    
  end
  
  it "should allow for more than one AppendixObject" do
    YARD.parse_string <<-'eof'
      module TheQuestion
        module TheAnswer
          # @!appendix 42
        end
        
        # @!appendix Life, the Universe, and Everything
        #
        # But what is it?
        
        # @!appendix DeepThought
        #
        # YEEHAA
      end
    eof
    
    appendixes = Registry.all(:appendix)
    appendixes.count.should == 3
    appendixes[0].namespace.should == Registry.at("TheQuestion::TheAnswer")
    appendixes[1].namespace.should == Registry.at("TheQuestion")
    appendixes[2].namespace.should == Registry.at("TheQuestion")
    
  end
  
  it "should implicitly prefix an appendix's title with Appendix: " do
    YARD.parse_string <<-'eof'
      module TheQuestion
        # @!appendix Life, the Universe, and Everything
        #
        # But what is it?
      end
    eof
    
    appendixes = Registry.all(:appendix)
    appendixes.count.should == 1
    appendixes[0].title.should == 'Appendix: Life, the Universe, and Everything'
    
  end
  
  it "should build an appendix in the root namespace" do
    YARD.parse_string <<-'eof'
      # @!appendix Life, the Universe, and Everything
      #
      # But what is it?
    eof
    
    appendixes = Registry.all(:appendix)
    appendixes.count.should == 1
    appendixes[0].namespace.should == Registry.root
  end
  
  it "should manage oddly titled appendices" do
    
    [ 'Appendix: Life, the Universe, and Everything',
      '#__ Booyah',
      '123456789',
      '\n',
      '<lol>'
    ].each do |some_title|
      YARD.parse_string %Q[
        module TheQuestion
          # @!appendix #{some_title}
          #
          # Some body.
        end
      ]
      
      appendixes = Registry.all(:appendix)
      appendixes.count.should == 1
      appendixes[0].title.should == 'Appendix: %s' %[some_title]
      
      Registry.clear
    end 
  end
  
  it "should ignore an appendix with no title" do
    log.should_receive(:warn).with(/Invalid directive format for @!appendix/)
    
    YARD.parse_string <<-'eof'
      module TheQuestion
        # @!appendix 
        #
        # But what is it?
      end
    eof
    
    
    Registry.all(:appendix).count.should == 0
  end
  
end