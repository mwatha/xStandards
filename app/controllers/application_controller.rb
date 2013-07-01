class ApplicationController < ActionController::Base
  protect_from_forgery

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

end
