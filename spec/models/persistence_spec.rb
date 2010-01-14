require File.dirname(__FILE__) + "/../spec_helper"
require 'models/persistence'

class PersistenceSpec < Test::Unit::TestCase
  
  def setup
    @persistence = Persistence.instance
  end

  it 'should be the same instance' do
    @persistence.should == Persistence.instance
  end

  it 'should initialize to application folder database file' do
    @persistence.db_path.should =~ /Application Support\/Pomodori/
  end

  it 'overrides default with init params' do
    @persistence.db_path = "here"
    @persistence.db_path.should == "here"
  end

  it 'overrides the bundles path' do
    @persistence.bundles_path = "here"
    @persistence.bundles_path.should == "here"
  end
  
  it 'creates the mom' do
    @persistence.bundles_path = [NSBundle.bundleWithPath(TEST_BUNDLE_PATH)]
    names = @persistence.mom.entities.collect {|e| e.name }
    names.include?("Pomodoro").should == true
  end

  it 'creates a persistent store coordinator' do
    @persistence.bundles_path = [NSBundle.bundleWithPath(TEST_BUNDLE_PATH)]
    @persistence.db_path = TEST_DB_PATH
    @persistence.psc.persistentStores.size.should > 0
  end

  it 'creates the moc' do
    @persistence.bundles_path = [NSBundle.bundleWithPath(TEST_BUNDLE_PATH)]
    @persistence.db_path = TEST_DB_PATH
    @persistence.moc.registeredObjects.count.should == 0
  end

  def teardown
    @persistence.reset
  end

end
