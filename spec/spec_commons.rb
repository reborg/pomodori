module SpecCommons
  
  def setup_persistence
    @persistence = Persistence.instance
    @persistence.bundles_path = [NSBundle.bundleWithPath(TEST_BUNDLE_PATH)]
    @persistence.db_path = TEST_DB_PATH
    @persistence
  end

  def teardown_persistence
    @persistence.reset 
    File.delete(TEST_DB_PATH) if File.exists?(TEST_DB_PATH)
  end

end
