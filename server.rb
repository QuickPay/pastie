require 'bundler/setup'
require 'sinatra'
require 'digest'
require 'aws-sdk-s3'

aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
aws_region = ENV['AWS_REGION']
aws_s3_bucket = ENV['AWS_S3_BUCKET']

Aws.config.update(
  access_key_id: aws_access_key_id,
  secret_access_key: aws_secret_access_key,
  force_path_style: true,
  region: aws_region
)

set :public_folder, File.dirname(__FILE__) + '/public'

# Store a document
post '/documents' do
  contents = request.body.read
  digest = Digest::MD5.base64digest(Time.now.to_f.to_s + contents).sub(/=*$/, '').gsub(/\//, '-')
  digest = "#{digest}.#{params[:type]}" if params[:type] =~ /^[A-z0-9\.]{,10}$/

  # FIXME: keep file support
  #File.open("public/documents/#{digest}", 'w') { |f| f.write contents }
  client = Aws::S3::Client.new
  obj = Aws::S3::Object.new(aws_s3_bucket, digest, client: client)

  obj.upload_stream do |write_stream|
    write_stream.binmode
    write_stream << contents
  end

  client.put_object_acl(
    bucket: aws_s3_bucket,
    key: digest,
    acl: 'public-read'
  )

  digest
end

get '/documents/:document' do

  client = Aws::S3::Client.new
  # FIXME: this should store the file in memory. we might want to look at getting the streaming solution below working instead.
  obj = client.get_object(bucket:aws_s3_bucket, key:params[:document])

  #content_type "application/octet-stream"
  #stream do |out|
  #  client.get_object(bucket:aws_s3_bucket, key:params[:document]) do |chunk, headers|
  #    chunk
  #  end
  #end

  obj.body
end

# Default GET request for sub-pages.
get '*' do
  content_type :html
  File.read 'public/index.html'
end
