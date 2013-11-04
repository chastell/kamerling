require 'sinatra/base'

module Kamerling class HTTPAPI < Sinatra::Base
  get '/' do
    <<-end.gsub(/^ {6}/, '')
      <!DOCTYPE html>
      <html>
        <head>
          <title>Kamerling</title>
        </head>
        <body>
          <nav>
            <ul>
              <li><a href='/projects' id='projects'>projects</a></li>
            </ul>
          </nav>
        </body>
      </html>
    end
  end
end end
