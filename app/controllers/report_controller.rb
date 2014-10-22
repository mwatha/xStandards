class ReportController < ApplicationController
  def index
  end

  def market_charts
    if request.post?
    results = get_market_data(params, params[:report]['report_type'])
      @samples = results[0]
      @colunm = results[1]
      @line_chart = results[2]
    end

    @report_type =  params[:report]['report_type']

    @date_range = [
      params[:report]['start_date'].to_date.strftime('%b/%Y'), 
      params[:report]['end_date'].to_date.strftime('%b/%Y')
    ]
  end

  def production_charts
    if request.post?
      results = get_production_data(params, params[:report]['report_type'])
      @samples = results[0]
      @colunm = results[1]
      @line_chart = results[2]
    end

    @report_type =  params[:report]['report_type']

    @date_range = [
      params[:report]['start_date'].to_date.strftime('%b/%Y'), 
      params[:report]['end_date'].to_date.strftime('%b/%Y')
    ]
  end

  def industry_charts
    if request.post?
      results = get_industry_data(params, params[:report]['report_type'])
      @samples = results[0]
      @colunm = results[1]
      @line_chart = results[2]
    end

    @report_type =  params[:report]['report_type']

    @date_range = [
      params[:report]['start_date'].to_date.strftime('%b/%Y'), 
      params[:report]['end_date'].to_date.strftime('%b/%Y')
    ]
  end
  
  private

  def get_production_data(params,type_of_report)
    @samples = {}
    avg_counter = {}
    result_counter = {}

    raw_data = RawDataQualityMonitoring.where("date >= ? AND date <=?",
      params[:report]['start_date'].to_date,params[:report]['end_date'].to_date)

    (raw_data || []).each do |sample|
      if type_of_report == "Iodine levels by salt brand and type"
        r = sample.country.name
      elsif type_of_report == "Iodine levels by customs station"
        r = sample.point_of_entry.name
      elsif type_of_report == "Iodine levels over time"
        r = quater(sample.date)
      elsif type_of_report == "Iodine levels by importer"
        r = sample.importer.name
      end

      if @samples[r].blank?
        @samples[r] = {
          :below_market_min => 0,
          :factory_min_market => 0,
          :below_factory_min => 0,
          :production_range => 0,
          :above_factory_max => 0,
          :num_of_samples => 0,
          :date => sample.date,
          :avg => 0,
        }

        result_counter[r] = 0
      end    
      
       case sample.category
        when "Below Market Min"
          @samples[r][:below_market_min] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when 'Factory Min-Market Min'
          @samples[r][:factory_min_market] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when '< Factory Min'
          @samples[r][:below_factory_min] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when 'Production Range'
          @samples[r][:production_range] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when '> Factory Max'
          @samples[r][:above_factory_max] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
      end

      result_counter[r] += sample.iodine_level
      @samples[r][:avg] = (result_counter[r]/@samples[r][:num_of_samples]).round(2)
    end

    #..........................................................................................

    @colunm = {}

    (raw_data || []).each do |sample|
      if type_of_report == "Iodine levels by salt brand and type"
        r = sample.country.name
      elsif type_of_report == "Iodine levels by customs station"
        r = sample.point_of_entry.name
      elsif type_of_report == "Iodine levels over time"
        r = quater(sample.date)
      elsif type_of_report == "Iodine levels by importer"
        r = sample.importer.name
      end

      if @colunm[r].blank?
        @colunm[r] = {
          :below_market_min => 0,
          :factory_min_market => 0,
          :below_factory_min => 0,
          :production_range => 0,
          :above_factory_max => 0,
          :num_of_samples => 0,
          :date => sample.date
        }

      end

      case sample.category
        when "Below Market Min"
          @colunm[r][:below_market_min] += sample.iodine_level unless sample.iodine_level.blank?
        when 'Factory Min-Market Min'
          @colunm[r][:factory_min_market] += sample.iodine_level unless sample.iodine_level.blank?
        when '< Factory Min'
          @colunm[r][:below_factory_min] += sample.iodine_level unless sample.iodine_level.blank?
        when 'Production Range'
          @colunm[r][:production_range] += sample.iodine_level unless sample.iodine_level.blank?
        when '> Factory Max'
          @colunm[r][:above_factory_max] += sample.iodine_level unless sample.iodine_level.blank?
      end

    end

    #.................................................................................................

    @line_chart = {}
   
    (raw_data.all || []).each do |sample|
      cat = sample.country.name
      if @line_chart[cat].blank?
        @line_chart[cat] = [0,0,0,0,0,0,0,0,0,0,0,0]
      end

      index = (sample.date.month - 1)
      if @line_chart[cat][index].blank?
        @line_chart[cat][index] = sample.iodine_level
      else
        @line_chart[cat][index] += sample.iodine_level
      end
    end

    return [@samples , @colunm , @line_chart]
  end

  def get_market_data(params,type_of_report)
    @samples = {}
    avg_counter = {}
    result_counter = {}

    raw_data = RawDataMarket.where("date >= ? AND date <=?",
      params[:report]['start_date'].to_date,params[:report]['end_date'].to_date)

    (raw_data || []).each do |sample|
      if type_of_report == "Iodine levels by salt brand and type"
        r = sample.manufacturer.name
      elsif type_of_report == "Iodine levels by district"
        r = sample.county.name
      else
        r = quater(sample.date)
      end
      if @samples[r].blank?
        @samples[r] = {
          :below_market_min => 0,
          :factory_min_market => 0,
          :below_factory_min => 0,
          :production_range => 0,
          :above_factory_max => 0,
          :num_of_samples => 0,
          :date => sample.date,
          :avg => 0,
        }

        result_counter[r] = 0
        
      end    

      case sample.category
        when "Below Market Min"
          @samples[r][:below_market_min] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when 'Factory Min-Market Min'
          @samples[r][:factory_min_market] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when '< Factory Min'
          @samples[r][:below_factory_min] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when 'Production Range'
          @samples[r][:production_range] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when '> Factory Max'
          @samples[r][:above_factory_max] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
      end

      result_counter[r] += sample.iodine_level 
      @samples[r][:avg] = (result_counter[r]/@samples[r][:num_of_samples]).round(2)
    end

    #..........................................................................................

    @colunm = {}

    (raw_data || []).each do |sample|
      if type_of_report == "Iodine levels by salt brand and type"
        r = sample.manufacturer.name
      elsif type_of_report == "Iodine levels by district"
        r = sample.county.name
      else
        r = quater(sample.date)
      end
      if @colunm[r].blank?
        @colunm[r] = {
          :below_market_min => 0,
          :factory_min_market => 0,
          :below_factory_min => 0,
          :production_range => 0,
          :above_factory_max => 0,
          :num_of_samples => 0,
          :date => sample.date
        }

      end    

      case sample.category
        when "Below Market Min"
          @colunm[r][:below_market_min] += sample.iodine_level unless sample.iodine_level.blank?
        when 'Factory Min-Market Min'
          @colunm[r][:factory_min_market] += sample.iodine_level unless sample.iodine_level.blank?
        when '< Factory Min'
          @colunm[r][:below_factory_min] += sample.iodine_level unless sample.iodine_level.blank?
        when 'Production Range'
          @colunm[r][:production_range] += sample.iodine_level unless sample.iodine_level.blank?
        when '> Factory Max'
          @colunm[r][:above_factory_max] += sample.iodine_level unless sample.iodine_level.blank?
      end

    end 

    #.................................................................................................


    @line_chart = {}
   
    (raw_data.all || []).each do |sample|
      cat = sample.manufacturer.name
      if @line_chart[cat].blank?
        @line_chart[cat] = [0,0,0,0,0,0,0,0,0,0,0,0]
      end

      index = (sample.date.month - 1)
      if @line_chart[cat][index].blank?
        @line_chart[cat][index] = sample.iodine_level
      else
        @line_chart[cat][index] += sample.iodine_level
      end
    end

    return [@samples , @colunm , @line_chart]
  end

  def get_industry_data(params,type_of_report)
    @samples = {}
    avg_counter = {}
    result_counter = {}

    raw_data = IndustryRawData.where("date >= ? AND date <=?",
      params[:report]['start_date'].to_date,params[:report]['end_date'].to_date)

    (raw_data || []).each do |sample|
      if type_of_report == "Iodine levels by company"
        r = sample.manufacturer.name
      else
        r = quater(sample.date)
      end

      if @samples[r].blank?
        @samples[r] = {
          :below_market_min => 0,
          :factory_min_market => 0,
          :below_factory_min => 0,
          :production_range => 0,
          :above_factory_max => 0,
          :num_of_samples => 0,
          :date => sample.date,
          :avg => 0,
        }

        result_counter[r] = 0
      end    

       case sample.category
        when "Below Market Min"
          @samples[r][:below_market_min] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when 'Factory Min-Market Min'
          @samples[r][:factory_min_market] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when '< Factory Min'
          @samples[r][:below_factory_min] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when 'Production Range'
          @samples[r][:production_range] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
        when '> Factory Max'
          @samples[r][:above_factory_max] += 1 unless sample.iodine_level.blank?
          @samples[r][:num_of_samples] += 1
      end

      result_counter[r] += sample.iodine_level
      @samples[r][:avg] = (result_counter[r]/@samples[r][:num_of_samples]).round(2)
    end

     #..........................................................................................

    @colunm = {}

    (raw_data || []).each do |sample|
      if type_of_report == "Iodine levels by company"
        r = sample.manufacturer.name
      else
        r = quater(sample.date)
      end

      if @colunm[r].blank?
        @colunm[r] = {
          :below_market_min => 0,
          :factory_min_market => 0,
          :below_factory_min => 0,
          :production_range => 0,
          :above_factory_max => 0,
          :num_of_samples => 0,
          :date => sample.date
        }

      end

      case sample.category
        when "Below Market Min"
          @colunm[r][:below_market_min] += sample.iodine_level unless sample.iodine_level.blank?
        when 'Factory Min-Market Min'
          @colunm[r][:factory_min_market] += sample.iodine_level unless sample.iodine_level.blank?
        when '< Factory Min'
          @colunm[r][:below_factory_min] += sample.iodine_level unless sample.iodine_level.blank?
        when 'Production Range'
          @colunm[r][:production_range] += sample.iodine_level unless sample.iodine_level.blank?
        when '> Factory Max'
          @colunm[r][:above_factory_max] += sample.iodine_level unless sample.iodine_level.blank?
      end

    end

    #.................................................................................................

    @line_chart = {}
   
    (raw_data.all || []).each do |sample|
      cat = sample.manufacturer.name
      if @line_chart[cat].blank?
        @line_chart[cat] = [0,0,0,0,0,0,0,0,0,0,0,0]
      end

      index = (sample.date.month - 1)
      if @line_chart[cat][index].blank?
        @line_chart[cat][index] = sample.iodine_level
      else
        @line_chart[cat][index] += sample.iodine_level
      end
    end

    return [@samples , @colunm , @line_chart]
  end

end
