Gem::Specification.new do |gem|
  gem.name     = 'kamerling'
  gem.version  = '0.0.0'
  gem.summary  = 'Kamerling: a computation network server'
  gem.homepage = 'https://github.com/chastell/kamerling'
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'p.szotkowski@tele.pw.edu.pl'
  gem.license  = 'AGPL-3.0'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename path }
  gem.test_files  = gem.files.grep %r{^spec/.*\.rb$}

  gem.add_dependency 'after_do', '~> 0.3.0'
  gem.add_dependency 'sequel',   '~> 4.4'
  gem.add_dependency 'sinatra',  '~> 1.4'
  gem.add_dependency 'slim',     '~> 2.0'
  gem.add_dependency 'sqlite3',  '~> 1.3'

  gem.add_development_dependency 'bogus',          '~> 0.1.3'
  gem.add_development_dependency 'minitest',       '~> 5.0'
  gem.add_development_dependency 'minitest-focus', '~> 1.1'
  gem.add_development_dependency 'nokogiri',       '~> 1.6'
  gem.add_development_dependency 'rack-test',      '~> 0.6.2'
  gem.add_development_dependency 'rake',           '~> 10.1'
  gem.add_development_dependency 'reek',           '~> 1.3'
  gem.add_development_dependency 'rerun',          '~> 0.8.2'
  gem.add_development_dependency 'rubocop',        '~> 0.18.0'
end
