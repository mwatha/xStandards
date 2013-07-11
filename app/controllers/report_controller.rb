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
      if type_of_report == "Iodinize levels by salt brand and type"
        r = sample.country.name
      elsif type_of_report == "Iodinize levels by customs station"
        r = sample.point_of_entry.name
      elsif type_of_report == "Iodinize levels over time"
        r = quater(sample.date)
      elsif type_of_report == "Iodinize levels by importer"
        r = sample.importer.name
      end

      if @samples[r].blank?
        @samples[r] = {
          :below_market_min => nil,
          :factory_min_market => nil,
          :below_factory_min => nil,
          :production_range => nil,
          :above_factory_max => nil,
          :num_of_samples => 0,
          :date => sample.date,
          :avg => 0,
        }

        avg_counter[r] = 0
        result_counter[r] = 0
      end    

      case sample.category
        when "Below Market Min"
          @samples[r][:below_market_min] += sample.iodine_level rescue  @samples[r][:below_market_min] = sample.iodine_level
        when 'Factory Min-Market Min'
          @samples[r][:factory_min_market] += sample.iodine_level rescue @samples[r][:factory_min_market] = sample.iodine_level
        when '< Factory Min'
          @samples[r][:below_factory_min] += sample.iodine_level rescue  @samples[r][:below_factory_min] = sample.iodine_level
        when 'Production Range'
          @samples[r][:production_range] += sample.iodine_level rescue @samples[r][:production_range] = sample.iodine_level
        when '> Factory Max'
          @samples[r][:above_factory_max] += sample.iodine_level rescue  @samples[r][:above_factory_max] = sample.iodine_level
      end

      result_counter[r] +=1 
      avg_counter[r] += sample.iodine_level
      @samples[r][:num_of_samples] += 1
      @samples[r][:avg] = (avg_counter[r]/result_counter[r]).round(2)
    end

    @colunm = {}
    colunm_avg = {}

    (@samples || {}).each do |quarter , values|
      if @colunm['Below Market Min'].blank?
        @colunm['Below Market Min'] = 0
      end
      @colunm['Below Market Min'] += values[:below_market_min] if values[:below_market_min]

      if @colunm['Factory Min-Market Min'].blank?
        @colunm['Factory Min-Market Min'] = 0
      end
      @colunm['Factory Min-Market Min'] += values[:factory_min_market] if values[:factory_min_market]

      if @colunm['Less than Factory Min'].blank?
        @colunm['Less than Factory Min'] = 0
      end
      @colunm['Less than Factory Min'] += values[:below_factory_min] if values[:below_factory_min]

      if @colunm['Production Range'].blank?
        @colunm['Production Range'] = 0
      end
      @colunm['Production Range'] += values[:production_range] if values[:production_range]

      if @colunm['Above Factory Max'].blank?
        @colunm['Above Factory Max'] = 0
      end
      @colunm['Above Factory Max'] += values[:above_factory_max] if values[:above_factory_max]
    end

    highest_value = 0
    (@colunm || {}).each do |cat , count|
      highest_value+=count
    end

    (@colunm || {}).each do |cat , count|
      @colunm[cat] = ((100/highest_value)* count).round(1)
    end

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
      if type_of_report == "Iodinize levels by salt brand and type"
        r = sample.manufacturer.name
      elsif type_of_report == "Iodinize levels by district"
        r = sample.district.name
      else
        r = quater(sample.date)
      end
      if @samples[r].blank?
        @samples[r] = {
          :below_market_min => nil,
          :factory_min_market => nil,
          :below_factory_min => nil,
          :production_range => nil,
          :above_factory_max => nil,
          :num_of_samples => 0,
          :date => sample.date,
          :avg => 0,
        }

        avg_counter[r] = 0
        result_counter[r] = 0
      end    

      case sample.category
        when "Below Market Min"
          @samples[r][:below_market_min] += sample.iodine_level rescue  @samples[r][:below_market_min] = sample.iodine_level
        when 'Factory Min-Market Min'
          @samples[r][:factory_min_market] += sample.iodine_level rescue @samples[r][:factory_min_market] = sample.iodine_level
        when '< Factory Min'
          @samples[r][:below_factory_min] += sample.iodine_level rescue  @samples[r][:below_factory_min] = sample.iodine_level
        when 'Production Range'
          @samples[r][:production_range] += sample.iodine_level rescue @samples[r][:production_range] = sample.iodine_level
        when '> Factory Max'
          @samples[r][:above_factory_max] += sample.iodine_level rescue  @samples[r][:above_factory_max] = sample.iodine_level
      end

      result_counter[r] +=1 
      avg_counter[r] += sample.iodine_level
      @samples[r][:num_of_samples] += 1
      @samples[r][:avg] = (avg_counter[r]/result_counter[r]).round(2)
    end

    @colunm = {}
    colunm_avg = {}

    (@samples || {}).each do |quarter , values|
      if @colunm['Below Market Min'].blank?
        @colunm['Below Market Min'] = 0
      end
      @colunm['Below Market Min'] += values[:below_market_min] if values[:below_market_min]

      if @colunm['Factory Min-Market Min'].blank?
        @colunm['Factory Min-Market Min'] = 0
      end
      @colunm['Factory Min-Market Min'] += values[:factory_min_market] if values[:factory_min_market]

      if @colunm['Less than Factory Min'].blank?
        @colunm['Less than Factory Min'] = 0
      end
      @colunm['Less than Factory Min'] += values[:below_factory_min] if values[:below_factory_min]

      if @colunm['Production Range'].blank?
        @colunm['Production Range'] = 0
      end
      @colunm['Production Range'] += values[:production_range] if values[:production_range]

      if @colunm['Above Factory Max'].blank?
        @colunm['Above Factory Max'] = 0
      end
      @colunm['Above Factory Max'] += values[:above_factory_max] if values[:above_factory_max]
    end

    highest_value = 0
    (@colunm || {}).each do |cat , count|
      highest_value+=count
    end

    (@colunm || {}).each do |cat , count|
      @colunm[cat] = ((100/highest_value)* count).round(1)
    end

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
      if type_of_report == "Iodinize levels by company"
        r = sample.manufacturer.name
      else
        r = quater(sample.date)
      end

      if @samples[r].blank?
        @samples[r] = {
          :below_market_min => nil,
          :factory_min_market => nil,
          :below_factory_min => nil,
          :production_range => nil,
          :above_factory_max => nil,
          :num_of_samples => 0,
          :date => sample.date,
          :avg => 0,
        }

        avg_counter[r] = 0
        result_counter[r] = 0
      end    

      case sample.category
        when "Below Market Min"
          @samples[r][:below_market_min] += sample.iodine_level rescue  @samples[r][:below_market_min] = sample.iodine_level
        when 'Factory Min-Market Min'
          @samples[r][:factory_min_market] += sample.iodine_level rescue @samples[r][:factory_min_market] = sample.iodine_level
        when '< Factory Min'
          @samples[r][:below_factory_min] += sample.iodine_level rescue  @samples[r][:below_factory_min] = sample.iodine_level
        when 'Production Range'
          @samples[r][:production_range] += sample.iodine_level rescue @samples[r][:production_range] = sample.iodine_level
        when '> Factory Max'
          @samples[r][:above_factory_max] += sample.iodine_level rescue  @samples[r][:above_factory_max] = sample.iodine_level
      end

      result_counter[r] +=1 
      avg_counter[r] += sample.iodine_level
      @samples[r][:num_of_samples] += 1
      @samples[r][:avg] = (avg_counter[r]/result_counter[r]).round(2)
    end

    @colunm = {}
    colunm_avg = {}

    (@samples || {}).each do |quarter , values|
      if @colunm['Below Market Min'].blank?
        @colunm['Below Market Min'] = 0
      end
      @colunm['Below Market Min'] += values[:below_market_min] if values[:below_market_min]

      if @colunm['Factory Min-Market Min'].blank?
        @colunm['Factory Min-Market Min'] = 0
      end
      @colunm['Factory Min-Market Min'] += values[:factory_min_market] if values[:factory_min_market]

      if @colunm['Less than Factory Min'].blank?
        @colunm['Less than Factory Min'] = 0
      end
      @colunm['Less than Factory Min'] += values[:below_factory_min] if values[:below_factory_min]

      if @colunm['Production Range'].blank?
        @colunm['Production Range'] = 0
      end
      @colunm['Production Range'] += values[:production_range] if values[:production_range]

      if @colunm['Above Factory Max'].blank?
        @colunm['Above Factory Max'] = 0
      end
      @colunm['Above Factory Max'] += values[:above_factory_max] if values[:above_factory_max]
    end

    highest_value = 0
    (@colunm || {}).each do |cat , count|
      highest_value+=count
    end

    (@colunm || {}).each do |cat , count|
      @colunm[cat] = ((100/highest_value)* count).round(1)
    end

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
