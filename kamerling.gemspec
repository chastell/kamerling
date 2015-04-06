Gem::Specification.new do |gem|
  gem.author      = 'Piotr Szotkowski'
  gem.description = 'A network server for distributing computations across ' \
                    'different clients speaking TCP or UDP.'
  gem.email       = 'p.szotkowski@tele.pw.edu.pl'
  gem.homepage    = 'https://github.com/chastell/kamerling'
  gem.license     = 'AGPL-3.0'
  gem.name        = 'kamerling'
  gem.summary     = 'Kamerling: a computation network server'
  gem.version     = '0.0.3'

  gem.files       = `git ls-files -z`.split("\0")
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename(path) }
  gem.test_files  = gem.files.grep(%r{^test/.*\.rb$})

  gem.add_dependency 'after_do',     '~> 0.3.0'
  gem.add_dependency 'equalizer',    '~> 0.0.9'
  gem.add_dependency 'private_attr', '~> 1.1'
  gem.add_dependency 'sequel',       '~> 4.4'
  gem.add_dependency 'sinatra',      '~> 1.4'
  gem.add_dependency 'slim',         '~> 3.0'
  gem.add_dependency 'sqlite3',      '~> 1.3'
  gem.add_dependency 'virtus',       '~> 1.0'

  gem.add_development_dependency 'bogus',          '~> 0.1.3'
  gem.add_development_dependency 'minitest',       '~> 5.0'
  gem.add_development_dependency 'minitest-focus', '~> 1.1'
  gem.add_development_dependency 'nokogiri',       '~> 1.6'
  gem.add_development_dependency 'rack-test',      '~> 0.6.2'
  gem.add_development_dependency 'rake',           '~> 10.1'
  gem.add_development_dependency 'reek',           '~> 2.0'
  gem.add_development_dependency 'rerun',          '~> 0.10.0'
  gem.add_development_dependency 'rubocop',        '~> 0.30.0'
end
