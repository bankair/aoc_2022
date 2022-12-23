# frozen_string_literal: true

group :development do
  # directories (1..24).to_a.map(&:to_s)

  guard :shell do
    watch(/\.rb/) do |modified_files|
      dir, name = File.split(modified_files[0])
      Dir.chdir(dir) { puts `ruby #{name}` }
    end
  end
end
