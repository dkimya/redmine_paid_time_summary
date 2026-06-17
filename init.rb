require File.expand_path('lib/redmine_paid_time_summary/hooks', __dir__)

Redmine::Plugin.register :redmine_paid_time_summary do
  name 'Redmine Paid Time Summary'
  author 'MP'
  description 'Adds paid issue count and total paid time to project overview pages.'
  version '0.1.0'
end
