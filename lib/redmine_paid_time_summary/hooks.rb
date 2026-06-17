require_relative '../../app/models/redmine_paid_time_summary'

module RedminePaidTimeSummary
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_projects_show_left,
              partial: 'redmine_paid_time_summary/project_overview_box'
  end
end
