require 'rubygems'
require 'sinatra'

require 'sinatra/flash'
require 'slim'
require 'yaml'
require 'json'
require 'logger'
require 'pry'

class App < Sinatra::Base
  register Sinatra::Flash

  enable :sessions


  get '/' do
    slim :form
  end
  post '/process_file' do
    upload = params[:upload]
    original_filename = upload[:filename]
    upload_filename = upload[:tempfile].path
    cmd = "file #{upload_filename} > #{upload_filename}"
    cmd_res = `#{cmd}`
    #upload[:tempfile].unlink
    output_file = "#{original_filename}.tsv"
    send_file upload_filename, :filename => output_file, :type => "text/tsv"
  end

end