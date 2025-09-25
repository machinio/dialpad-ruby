Gem::Specification.new do |spec|
  spec.name          = 'dialpad'
  spec.version       = '0.1.0'
  spec.authors       = ['Anatoly Shvets']
  spec.email         = ['anatoly.shvets@machinio.com']

  spec.summary       = 'Ruby client for Dialpad API'
  spec.description   = 'A Ruby gem that provides access to the Dialpad API with CRUD operations for webhooks, subscriptions, contacts, and calls.'
  spec.homepage      = 'https://github.com/maddale/dialpad-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'json', '~> 2.0'

  spec.required_ruby_version = '>= 3.4.2'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
