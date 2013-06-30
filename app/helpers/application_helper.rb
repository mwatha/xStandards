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

end
