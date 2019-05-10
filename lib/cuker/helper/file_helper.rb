module FileHelper
  def self.get_files loc, target_pattern, ignore_patterns = nil
    Dir.glob("#{loc}/**/*#{target_pattern}").select {|x| x !~ ignore_patterns}
  end
end