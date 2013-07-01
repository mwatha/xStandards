class TransporterController < ApplicationController
  def new
    @types = TransporterType.order('name ASC').collect do |t|
      [t.name , t.id]
    end
  end

  def create
    Transporter.transaction do 
      transporter = Transporter.new()
      transporter.name = params[:transporter]['name']
      transporter.transporter_type = params[:transporter]['type']
      unless params[:transporter]['description'].blank?
        transporter.description = params[:transporter]['description']
      end
      if transporter.save                                                              
        flash[:notice] = 'Successfully created.'                                
      else                                                                      
        flash[:error] = 'Something went wrong - did not create.'                
      end                                                                       
    end                                                                         
    redirect_to '/newtransporter'
  end

end
