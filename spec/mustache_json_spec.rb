require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Mustache do
  class MustachioedPerson < Mustache
    def first_name
      "Bob"
    end
    
    def last_name
      "Stevens"
    end
    
    protected
    
    def dont_show
      "secrets"
    end
    
    private
    
    def really_secret
      "bad stuff"
    end
  end
  
  describe '#serializable_hash' do
    before do
      @stache = MustachioedPerson.new
      @hash = @stache.serializable_hash
    end
    
    it 'should include publicly declared methods' do
      @hash[:first_name].should == 'Bob'
      @hash[:last_name].should == 'Stevens'
    end
    
    it 'should not include protected or private methods' do
      @hash.keys.should_not be_include(:dont_show)
      @hash.keys.should_not be_include(:really_secret)
    end
    
    it 'should include any additional context' do
      @stache.context.update(:foo => 'bar')
      @stache.serializable_hash[:foo].should == 'bar'
    end
  end
  
  describe '.serializable_methods' do
    it 'should be the public instance methods of the specific class' do
      MustachioedPerson.serializable_methods.should == MustachioedPerson.public_instance_methods(false)
    end
  end
  
  describe '#to_json' do
    before do
      @stache = MustachioedPerson.new
    end
    
    [:json_gem, :json_pure, :yajl, :active_support].each do |backend|
      describe " with the #{backend} backend" do
        before do
          Mustache::JSON.backend = backend
        end
        
        it 'should call the appropriate backend' do
          Mustache::JSON.class_for(backend).should_receive(:encode)
          @stache.to_json
        end
        
        it 'should include expected values' do
          @stache.to_json.should be_include('"first_name":"Bob"')
        end
      end
    end
  end
end
