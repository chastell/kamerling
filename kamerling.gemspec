Gem::Specification.new do |gem|
  gem.name     = 'kamerling'
  gem.version  = '0.0.0'
  gem.summary  = 'Kamerling: a computation network server'
  gem.homepage = 'https://github.com/chastell/kamerling'
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'p.szotkowski@tele.pw.edu.pl'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename path }
  gem.test_files  = gem.files.grep %r{^spec/.*\.rb$}

  gem.add_dependency 'eventmachine'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'em-ventually'
  gem.add_development_dependency 'minitest', '~> 4.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rb-inotify'
  gem.add_development_dependency 'rerun'
end
