require 'rubygems'
require 'sinatra'

require 'sinatra/flash'
require 'slim'
require 'yaml'
require 'json'
require 'logger'
require 'pry'
require 'tempfile'

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
    tempfile = Tempfile.new('tesseract_outputbase__')
    output_fn = tempfile.path
    tempfile.close(unlink_now=true)
    cmd = "app/tesseract-ocr/bin/tesseract #{upload_filename} #{output_fn} hocrtsv"
    cmd_res = `#{cmd}`
    output_file = "#{original_filename}.hocr.tsv"
    output_fn = "#{output_fn}.hocr.tsv"
    send_file output_fn, :filename => output_file, :type => "text/tsv"
    upload[:tempfile].unlink
    File.unlink(output_fn)
  end

end
