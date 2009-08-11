# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # like link_to_unless_current but wraps text in tag if current, and keeps link in either case
  def link_to_tag_unless_current( name, options={}, tag=:span, html_options={}, &block)
    content = link_to(name, options, html_options, &block)   
    if current_page?(options) 
      content_tag(tag, content)
    else
      content
    end
  end
  
  def form_help( topic )
    "<img src=\"/images/icon_help.gif\" style=\"width:12px; height:12px\"
      title=\"#{topic.to_s.humanize}: #{HELP_TOPICS[topic]}.\"
      onclick=\"alert('#{topic.to_s.humanize}: #{HELP_TOPICS[topic]}.')\" />"
  end
  
  HELP_TOPICS = {
    :hn_plan => 'If you tell us your HughesNet service plan (and Fair Access Policy threshold) we can initialize the Warning and Alert thresholds. Of course, you can change these settings in your Preferences. Leave blank and levels are set to minimum values',
    :site_ID => 'Your HughesNet Site ID can be found, for example, on the System Info page of your modem System Control Center',
    :site_id_not_editable => 'The Site ID cannot be changed once the Husage reports have been initialized. To change you must delete this Husage report and register a new one',
    :warning_threshold => 'Number of megabytes (MB) which signals a Warning for high internet usage downloads. For example, a value of 250 or 300 may be reasonable if your HughesNet FAP maximum is 400 MB',
    :alert_threshold => 'Number of megabytes (MB) which signals a red Alert for high internet usage downloads. For example, a value of 325 or 350 may be reasonable if your HughesNet FAP maximum is 400 MB',
    :run_hourly => 'If checked, your usage report will be re-calculated once an hour. When not checked, reports are not automatically updated and alerts will not be sent out',
    :email => 'Your primary email address where warning and alert messages will be sent. Also used when resetting your lost password, and other communications',
    :other_emails => 'Additional email addresses where warning and alert message will be sent. Put emails on separate lines or separate with commas',
    :send_emails => 'If checked, email warning and alert messages will be sent to the primary and other email addresses when the reports are re-calculated',
    :password => 'Choosing a secret password lets you log in to get your Husage reports. Note, your registration and password here is not affiliated with other HughesNet accounts you might have.',
    :time_zone => 'Times in the reports will be converted to your local time zone',
    :delete_site => 'Delete this log-in and all reports for the HughesNet Site ID. (Does not affect your HughesNet account in any way)'
  }
  
  def button_with_disable_to( name, options={}, html_options={} )
    # adapted from #submit_tag (File rails-2.3.2/actionpack/lib/action_view/helpers/form_tag_helper.rb, line 348)
    html_options.stringify_keys!
    disable_with = html_options.delete("disable_with")
    disable_with ||= "One moment please- Processing..."
    disable_with = "this.value='#{disable_with}'"
    html_options["onclick"]  = "if (window.hiddenCommit) { window.hiddenCommit.setAttribute('value', this.value); }"
    html_options["onclick"] << "else { hiddenCommit = this.cloneNode(false);hiddenCommit.setAttribute('type', 'hidden');this.form.appendChild(hiddenCommit); }"
    html_options["onclick"] << "this.setAttribute('originalValue', this.value);this.disabled = true;#{disable_with};"
    html_options["onclick"] << "result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit());"
    html_options["onclick"] << "if (result == false) { this.value = this.getAttribute('originalValue');this.disabled = false; }return result;"
    button_to name, options, html_options
  end
  
  
end
