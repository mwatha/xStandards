class ReportController < ApplicationController
  def index
  end

  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  def industry_charts
    if request.post?
      @samples = {}
      avg_counter = {}
      result_counter = {}

      raw_data = IndustryRawData.where("date >= ? AND date <=?",
        params[:report]['start_date'].to_date,params[:report]['end_date'].to_date)

      (raw_data || []).each do |sample|
        quarter = quater(sample.date)
        if @samples[quarter].blank?
          @samples[quarter] = {
            :below_market_min => nil,
            :factory_min_market => nil,
            :below_factory_min => nil,
            :production_range => nil,
            :above_factory_max => nil,
            :avg => 0,
          }

          avg_counter[quarter] = 0
          result_counter[quarter] = 0
        end    

        case sample.category
          when "Below Market Min"
            @samples[quarter][:below_market_min] += sample.iodine_level rescue  @samples[quarter][:below_market_min] = sample.iodine_level
          when 'Factory Min-Market Min'
            @samples[quarter][:factory_min_market] += sample.iodine_level rescue @samples[quarter][:factory_min_market] = sample.iodine_level
          when '< Factory Min'
            @samples[quarter][:below_factory_min] += sample.iodine_level rescue  @samples[quarter][:below_factory_min] = sample.iodine_level
          when 'Production Range'
            @samples[quarter][:production_range] += sample.iodine_level rescue @samples[quarter][:production_range] = sample.iodine_level
          when '> Factory Max'
            @samples[quarter][:above_factory_max] += sample.iodine_level rescue  @samples[quarter][:above_factory_max] = sample.iodine_level
        end

        result_counter[quarter] +=1 
        avg_counter[quarter] += sample.iodine_level
        @samples[quarter][:avg] = (avg_counter[quarter]/result_counter[quarter]).round(2)
      end
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
=begin
      if count >= highest_value
        highest_value = count
      end
=end
      highest_value+=count
    end

    (@colunm || {}).each do |cat , count|
      @colunm[cat] = ((100/highest_value)* count).round(1)
    end

    @line_chart = {}
     
    (raw_data.all || []).each do |sample|
      cat = sample.category
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

    @date_range = [
      params[:report]['start_date'].to_date.strftime('%b/%Y'), 
      params[:report]['end_date'].to_date.strftime('%b/%Y')
    ]
  end

  def market_charts
    if request.post?
      if params[:report]['report_type'] == 'Iodinize levels by district'
      elsif params[:report]['report_type'] == 'Iodinize levels by salt brand and type'
        results = market_chart_levels_salt_brand(params)
        @samples = results[0]
        @colunm = results[1]
        @line_chart = results[2]
      else
        results = market_chart_levels_overtime(params)
        @samples = results[0]
        @colunm = results[1]
        @line_chart = results[2]
      end
    end

    @report_type =  params[:report]['report_type']

    @date_range = [
      params[:report]['start_date'].to_date.strftime('%b/%Y'), 
      params[:report]['end_date'].to_date.strftime('%b/%Y')
    ]
  end

  def production_charts
    if request.post?
      @samples = {}
      avg_counter = {}
      result_counter = {}

      raw_data = RawDataQualityMonitoring.where("date >= ? AND date <=?",
        params[:report]['start_date'].to_date,params[:report]['end_date'].to_date)

      (raw_data || []).each do |sample|
        quarter = quater(sample.date)
        if @samples[quarter].blank?
          @samples[quarter] = {
            :below_market_min => nil,
            :factory_min_market => nil,
            :below_factory_min => nil,
            :production_range => nil,
            :above_factory_max => nil,
            :avg => 0,
          }

          avg_counter[quarter] = 0
          result_counter[quarter] = 0
        end    

        case sample.category
          when "Below Market Min"
            @samples[quarter][:below_market_min] += sample.iodine_level rescue  @samples[quarter][:below_market_min] = sample.iodine_level
          when 'Factory Min-Market Min'
            @samples[quarter][:factory_min_market] += sample.iodine_level rescue @samples[quarter][:factory_min_market] = sample.iodine_level
          when '< Factory Min'
            @samples[quarter][:below_factory_min] += sample.iodine_level rescue  @samples[quarter][:below_factory_min] = sample.iodine_level
          when 'Production Range'
            @samples[quarter][:production_range] += sample.iodine_level rescue @samples[quarter][:production_range] = sample.iodine_level
          when '> Factory Max'
            @samples[quarter][:above_factory_max] += sample.iodine_level rescue  @samples[quarter][:above_factory_max] = sample.iodine_level
        end

        result_counter[quarter] +=1 
        avg_counter[quarter] += sample.iodine_level
        @samples[quarter][:avg] = (avg_counter[quarter]/result_counter[quarter]).round(2)
      end
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
=begin
      if count >= highest_value
        highest_value = count
      end
=end
      highest_value+=count
    end

    (@colunm || {}).each do |cat , count|
      @colunm[cat] = ((100/highest_value)* count).round(1)
    end

    @line_chart = {}
     
    (raw_data.all || []).each do |sample|
      cat = sample.category
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

    @date_range = [
      params[:report]['start_date'].to_date.strftime('%b/%Y'), 
      params[:report]['end_date'].to_date.strftime('%b/%Y')
    ]
  end

  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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

  private

  def market_chart_levels_overtime(params)
    @samples = {}
    avg_counter = {}
    result_counter = {}

    raw_data = RawDataMarket.where("date >= ? AND date <=?",
      params[:report]['start_date'].to_date,params[:report]['end_date'].to_date)

    (raw_data || []).each do |sample|
      quarter = quater(sample.date)
      if @samples[quarter].blank?
        @samples[quarter] = {
          :below_market_min => nil,
          :factory_min_market => nil,
          :below_factory_min => nil,
          :production_range => nil,
          :above_factory_max => nil,
          :avg => 0,
        }

        avg_counter[quarter] = 0
        result_counter[quarter] = 0
      end    

      case sample.category
        when "Below Market Min"
          @samples[quarter][:below_market_min] += sample.iodine_level rescue  @samples[quarter][:below_market_min] = sample.iodine_level
        when 'Factory Min-Market Min'
          @samples[quarter][:factory_min_market] += sample.iodine_level rescue @samples[quarter][:factory_min_market] = sample.iodine_level
        when '< Factory Min'
          @samples[quarter][:below_factory_min] += sample.iodine_level rescue  @samples[quarter][:below_factory_min] = sample.iodine_level
        when 'Production Range'
          @samples[quarter][:production_range] += sample.iodine_level rescue @samples[quarter][:production_range] = sample.iodine_level
        when '> Factory Max'
          @samples[quarter][:above_factory_max] += sample.iodine_level rescue  @samples[quarter][:above_factory_max] = sample.iodine_level
      end

      result_counter[quarter] +=1 
      avg_counter[quarter] += sample.iodine_level
      @samples[quarter][:avg] = (avg_counter[quarter]/result_counter[quarter]).round(2)
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
=begin
      if count >= highest_value
        highest_value = count
      end
=end
      highest_value+=count
    end

    (@colunm || {}).each do |cat , count|
      @colunm[cat] = ((100/highest_value)* count).round(1)
    end

    @line_chart = {}
   
    (raw_data.all || []).each do |sample|
      cat = sample.category
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

  def market_chart_levels_salt_brand(params)
    @samples = {}
    avg_counter = {}
    result_counter = {}

    raw_data = RawDataMarket.where("date >= ? AND date <=?",
      params[:report]['start_date'].to_date,params[:report]['end_date'].to_date)

    (raw_data || []).each do |sample|
      salt_brand = sample.manufacturer.name
      if @samples[salt_brand].blank?
        @samples[salt_brand] = {
          :below_market_min => nil,
          :factory_min_market => nil,
          :below_factory_min => nil,
          :production_range => nil,
          :above_factory_max => nil,
          :avg => 0,
        }

        avg_counter[salt_brand] = 0
        result_counter[salt_brand] = 0
      end    

      case sample.category
        when "Below Market Min"
          @samples[salt_brand][:below_market_min] += sample.iodine_level rescue  @samples[salt_brand][:below_market_min] = sample.iodine_level
        when 'Factory Min-Market Min'
          @samples[salt_brand][:factory_min_market] += sample.iodine_level rescue @samples[salt_brand][:factory_min_market] = sample.iodine_level
        when '< Factory Min'
          @samples[salt_brand][:below_factory_min] += sample.iodine_level rescue  @samples[salt_brand][:below_factory_min] = sample.iodine_level
        when 'Production Range'
          @samples[salt_brand][:production_range] += sample.iodine_level rescue @samples[salt_brand][:production_range] = sample.iodine_level
        when '> Factory Max'
          @samples[salt_brand][:above_factory_max] += sample.iodine_level rescue  @samples[salt_brand][:above_factory_max] = sample.iodine_level
      end

      result_counter[salt_brand] +=1 
      avg_counter[salt_brand] += sample.iodine_level
      @samples[salt_brand][:avg] = (avg_counter[salt_brand]/result_counter[salt_brand]).round(2)
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
=begin
      if count >= highest_value
        highest_value = count
      end
=end
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
