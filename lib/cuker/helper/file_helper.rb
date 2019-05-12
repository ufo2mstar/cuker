module FileHelper
  def self.get_files loc, target_pattern, ignore_patterns = nil
    Dir.glob("#{loc}/**/*#{target_pattern}").select {|x| x !~ ignore_patterns}
  end

  def self.file_path loc,file_name
    FileUtils.mkdir_p(loc) unless Dir.exist? loc
    File.join(loc, file_name)
  end
end