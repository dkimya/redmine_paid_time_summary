require_dependency 'redmine_paid_time_summary'

class RedminePaidTimeSummaryHook < Redmine::Hook::ViewListener
  render_on :view_projects_show_left,
            partial: 'redmine_paid_time_summary/project_overview_box'
end
