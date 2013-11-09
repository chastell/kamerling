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

  gem.add_dependency 'sequel'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'slim'
  gem.add_dependency 'sqlite3'

  gem.add_development_dependency 'bogus',          '>= 0.1.3'
  gem.add_development_dependency 'minitest',       '~> 5.0'
  gem.add_development_dependency 'minitest-focus', '~> 1.1'
  gem.add_development_dependency 'nokogiri'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rake',           '~> 10.1'
  gem.add_development_dependency 'reek'
  gem.add_development_dependency 'rerun'
  gem.add_development_dependency 'rubocop'
end
