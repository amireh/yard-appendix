include Handlers::Ruby

describe YARD::Handlers::Ruby::AppendixHandler do
  
  before {
    Registry.clear
    
    class StubHandler < AppendixHandler
      handles :class, :module
      
      def self.resolver; @@resolver end
      def process; @@resolver ||= globals.resolver end

      # have to do this manually as to not clutter up the other specs
      AppendixHandler.clear_subclasses
    end
    
    AppendixHandler.inherited(StubHandler)
  }
  
  after {
    AppendixHandler.clear_subclasses
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
    class StubCommentHandler < Handlers::Ruby::Base
      handles :comment
      
      class << self
        def comments; @@comments end
      end
      
      def process
        @@comments ||= []
        @@comments << [ statement, namespace ] if statement.type == :comment
      end
    end
    
        
    YARD.parse_string <<-'eof'
      module SomeModule
        class SomeClass
          def f() end
          # comment in SomeClass
        end
        
        # comment in SomeModule
      end
      
      # comment in :root
    eof
    
    comments = StubCommentHandler.comments
    comments.size.should == 3
    
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
      should == Registry.at('SomeModule')
      
    resolver.
      namespace_for(
        comments[2][0],
        comments[2][1]).
      should == Registry.at(:root)
    
  end
  
end