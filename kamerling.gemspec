require 'English'
require 'pathname'

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

  gem.cert_chain  = ['certs/chastell.pem']
  if Pathname.new($PROGRAM_NAME).basename == Pathname.new('gem')
    gem.signing_key = Pathname.new('~/.ssh/gem-private_key.pem').expand_path
  end

  gem.add_dependency 'after_do',  '~> 0.4.0'
  gem.add_dependency 'equalizer', '~> 0.0.9'
  gem.add_dependency 'procto',    '~> 0.0.3'
  gem.add_dependency 'sequel',    '~> 5.0'
  gem.add_dependency 'sinatra',   '>= 2', '< 4'
  gem.add_dependency 'slim',      '~> 4.0'
  gem.add_dependency 'sqlite3',   '~> 1.3'
  gem.add_dependency 'virtus',    '~> 1.0'

  gem.add_development_dependency 'bogus',               '~> 0.1.3'
  gem.add_development_dependency 'minitest',            '~> 5.6'
  gem.add_development_dependency 'minitest-focus',      '~> 1.1'
  gem.add_development_dependency 'nokogiri',            '~> 1.6'
  gem.add_development_dependency 'overcommit',          '~> 0.46.0'
  gem.add_development_dependency 'rack-test',           '~> 1.0'
  gem.add_development_dependency 'rake',                '~> 12.0'
  gem.add_development_dependency 'reek',                '~> 5.0'
  gem.add_development_dependency 'rubocop',             '~> 0.65.0'
  gem.add_development_dependency 'ruby_warning_filter', '~> 1.0'
end
