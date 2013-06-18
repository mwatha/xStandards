module ApplicationHelper
  def app_name
    'xStandards'
  end

  def organization_name
    'Ministry Of Health'
  end

  def about_organization
    <<EOF
    The current overall policy goal of the health sector, which continues from the previous National Health Plan (1986-1995), is to raise the level of health status of all Malawians by reducing the incidence of illness and occurrence of death in the population. This will be done through the development of a sound delivery system capable of promoting health, preventing, reducing and curing disease, protecting life and fostering general well being and increased productivity.
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

end
