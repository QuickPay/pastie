require 'bundler/setup'
require 'sinatra'
require 'digest'

set :public_folder, File.dirname(__FILE__) + '/public'

# Store a document
post '/documents' do
  contents = request.body.read
  digest = Digest::MD5.base64digest(contents).sub(/=*$/, '').gsub(/\//, '-')

  File.open("public/documents/#{digest}", 'w') { |f| f.write contents }

  digest
end

# Default GET request for sub-pages.
get '*' do
  content_type :html
  File.read 'public/index.html'
end
