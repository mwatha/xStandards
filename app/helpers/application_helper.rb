module ApplicationHelper
  def app_name
    'xStandards'
  end

  def organization_name
    'Ministry Of Health'
  end

  def about_organization
    <<EOF
    <b>Salt Iodization Monitoring Tool</b><br />
    Border, Industry and Market Level Control.
EOF

  end

  def print_content(str)                                                           
    return '' if str.blank?                                                     
    str.html_safe.gsub(/\r\n?/,"<br/>")                                         
  end

  def admin?
    unless User.current_user.blank?
      User.current_user.user_roles.map(&:role).include?('admin') 
    end
  end

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
