module FileHelpers
  def rewrite_file file_path, content
    old_content = File.open(file_path, &:read)
    begin
      File.open(file_path, 'w'){|f| f.write content}
      yield
    ensure
      File.open(file_path, 'w'){|f| f.write old_content}
    end
  end
end