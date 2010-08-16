Gem::Specification.new do |spec|
  spec.name = 'condom'
  spec.author = 'Vivien Didelot'
  spec.email = 'vivien.didelot@gmail.com'
  spec.version = '0.2.0'
  spec.summary = 'A Ruby gem to create a skeleton for a LaTeX document.'
  spec.require_path = 'lib'
  spec.files = Dir['lib/**/*']
  spec.files << 'README.rdoc'
  spec.files << 'CHANGELOG.rdoc'
  spec.executables << 'condom'
end
