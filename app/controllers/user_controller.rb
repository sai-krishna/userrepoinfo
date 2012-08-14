require "prawn"
class UserController < ApplicationController

  def index


   

  end


def show_pdf_link
@link= params[:pdf_name]
respond_to do |format|
format.html #show_pdf_link.html.erb
end
end

  def make_pdf
     github = Github.new 
   @user=github.repos.list :user => params[:name]
   file_name=params[:name]+".pdf"

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

