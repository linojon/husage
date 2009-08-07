class InfoController < ApplicationController
  
  def show
    render :action => params[:id]
  end
  
end
