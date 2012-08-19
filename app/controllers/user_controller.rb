require "prawn"
require 'net/http'
require 'net/https'
require 'uri'
require 'json'
class UserController < ApplicationController

  def index


#redirect_to => "https://github.com/login/oauth/authorize?client_id=19d4df26ccfd1d35f7eb&state=123"
   

  end


def show_pdf_link
@link= params[:pdf_name]
respond_to do |format|
format.html #show_pdf_link.html.erb
end
end

  def make_pdf



uri = URI.parse("https://github.com/login/oauth/access_token")
# Full control
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(uri.request_uri)
request.set_form_data({"client_id" => "19d4df26ccfd1d35f7eb", "client_secret" => "954b0ad9c956d4e5297651a35fa5da9a602a18d4", "code" => "#{params[:code]}", "state" => "123" })

response = http.request(request)
  

token=(response.body.split("&")[0]).split("=")[1]



uri = URI.parse("https://api.github.com/user?access_token=#{token}")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)

api_response = http.request(request)
user_name = JSON.parse(api_response.body)["login"]

     github = Github.new 
   @user=github.repos.list :user => user_name
   file_name=user_name+".pdf"

repos=[]
repos[0]=["repo_name","description","created_at"]
@user.each do |repo|
repos << [repo["name"],repo["description"],repo["created_at"]]
end

Prawn::Document.generate("#{Rails.root}/public/#{file_name}") do
table(repos)
end

redirect_to :action => "show_pdf_link", :pdf_name => file_name

  end


end


