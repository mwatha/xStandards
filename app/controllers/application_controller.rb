class ApplicationController < ActionController::Base
  #protect_from_forgery

  before_filter :perform_basic_auth, :except => ['login','logout']                         

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
                                                                                
  def perform_basic_auth                                                        
    if session[:user_id].blank?                                                 
      respond_to do |format|                                                    
        format.html { redirect_to :controller => 'user',:action => 'logout' }   
      end                                                                       
    elsif not session[:user_id].blank?                                          
      User.current_user = User.where(:'id' => session[:user_id]).first        
    end                                                                         
  end 

end
