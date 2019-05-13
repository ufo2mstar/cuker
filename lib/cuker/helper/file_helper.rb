module FileHelper
  def self.get_files path, target_pattern, ignore_patterns = nil
    Dir.glob("#{path}/**/*#{target_pattern}").select {|x| x !~ ignore_patterns}
  end

  def self.get_file file_name, target_pattern, ignore_patterns = nil
    Dir.glob("*#{file_name}*#{target_pattern}").select {|x| x !~ ignore_patterns}
  end

  def self.file_path path, file_name
    FileUtils.mkdir_p(path) unless Dir.exist? path
    File.join(path, file_name)
  end
end