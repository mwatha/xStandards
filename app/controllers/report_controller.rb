class ReportController < ApplicationController
  def index
  end

  def production_line_chart
    start_date = params[:start_date].to_date rescue nil
    end_date = params[:end_date].to_date rescue nil
    
    if start_date.blank? or end_date.blank?
      render :text => '' and return 
    elsif start_date > end_date
      render :text => '' and return 
    end

    @fetched_data = {}
    (Sample.order('date ASC') || []).each do |sample|
      key = sample.product.manufacturer.name
      if @fetched_data[key].blank?
        @fetched_data[key] = [
          0,0,0,0,0,0,0,0,0,0,0,0
        ]
      end
      index = (sample.date.month - 1)
      @fetched_data[key][index] = sample.iodine_level
    end
    render :layout => false
  end

  def production_pie_chart
    @fetched_data = Hash.new(0)
    samples = Sample.order('date ASC').where("date BETWEEN (?) AND (?)",
      params[:start_date].to_date,params[:end_date].to_date)

    (samples || []).each do |sample|
      key = sample.product.manufacturer.name
      @fetched_data[key] += sample.iodine_level
    end
    render :layout => false
  end

end
