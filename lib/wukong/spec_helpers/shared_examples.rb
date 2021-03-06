shared_examples_for 'a processor' do |options = {}|
  it 'is registered' do
    Wukong.registry.retrieve(options[:named].to_sym).should_not be_nil
  end
  it{ processor(options[:named]).processor.should respond_to(:setup)    }
  it{ processor(options[:named]).processor.should respond_to(:process)  }
  it{ processor(options[:named]).processor.should respond_to(:finalize) }
  it{ processor(options[:named]).processor.should respond_to(:stop)     }
end

shared_examples_for 'a plugin' do |options = {}|
  it "is registered as a Wukong plugin " do
    Wukong::PLUGINS.should include(subject)
  end
  it { should respond_to(:configure) }
  it { should respond_to(:boot)      }
end

shared_examples_for 'a model class' do |options = {}|
  it        { should respond_to(:receive) }
  its(:new) { should respond_to(:to_wire) }
end
