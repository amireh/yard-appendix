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