require_relative 'lib/flexdot/version'

Gem::Specification.new do |spec|
  spec.name          = 'flexdot'
  spec.version       = Flexdot::VERSION
  spec.authors       = ['Katsuya Hidaka']
  spec.email         = ['hidakatsuya@gmail.com']

  spec.summary       = 'A Flexible and Rake based dotfile manager'
  spec.description   = 'Flexdot is a Flexible and Rake based dotfile manager'
  spec.homepage      = 'https://github.com/hidakatsuya/flexdot'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  end
  spec.require_paths = ['lib']
end
