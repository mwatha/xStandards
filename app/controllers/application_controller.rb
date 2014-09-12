class ApplicationController < ActionController::Base
  #protect_from_forgery
  before_filter :check_logged_in, :except => ['login','logout']

  def quater(date)                                                              
    month = date.month                                                          
    if month <= 3                                                               
      return "Q1 #{date.year}"                                                  
    elsif month >= 4 and month <= 6                                             
      return "Q2 #{date.year}"                                                  
    elsif month >= 7 and month <= 9                                             
      return "Q3 #{date.year}"                                                  
    else                                                                        
      return "Q4 #{date.year}"                                                  
    end                                                                         
  end 

  protected

  def check_logged_in

    if session[:user_id].blank?
      respond_to do |format|
        format.html { redirect_to '/login' }
      end
    elsif not session[:user_id].blank?
      User.current_user = User.find(session[:user_id])
    end
  end
end
