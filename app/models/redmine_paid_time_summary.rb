module RedminePaidTimeSummary
  INVOICED_CUSTOM_FIELD_ID = 72
  INVOICED_VALUE = '1'

  Result = Struct.new(:paid_issues_count, :total_paid_hours, keyword_init: true)

  module_function

  def for_project(project)
    return empty_result unless project

    paid_entries = paid_time_entries_for(project)

    Result.new(
      paid_issues_count: paid_entries.distinct.count("#{Issue.table_name}.id"),
      total_paid_hours: paid_entries.sum("#{TimeEntry.table_name}.hours").to_f
    )
  end

  def empty_result
    Result.new(paid_issues_count: 0, total_paid_hours: 0.0)
  end

  def paid_time_entries_for(project)
    base_time_entry_scope
      .joins(:issue)
      .joins(paid_issue_custom_value_join)
      .where("#{TimeEntry.table_name}.project_id IN (?)", project_and_descendant_ids(project))
      .where(
        'paid_issue_custom_values.custom_field_id = ? AND paid_issue_custom_values.value = ?',
        INVOICED_CUSTOM_FIELD_ID,
        INVOICED_VALUE
      )
  end

  def project_and_descendant_ids(project)
    [project.id] + project.descendants.pluck(:id)
  end

  def format_hours_as_hhmm(hours)
    total_minutes = (hours.to_f * 60).round

    format('%d:%02d', total_minutes / 60, total_minutes % 60)
  end

  def base_time_entry_scope
    TimeEntry.respond_to?(:visible) ? TimeEntry.visible : TimeEntry.all
  end

  def paid_issue_custom_value_join
    <<~SQL.squish
      INNER JOIN #{CustomValue.table_name} paid_issue_custom_values
        ON paid_issue_custom_values.customized_type = 'Issue'
       AND paid_issue_custom_values.customized_id = #{Issue.table_name}.id
    SQL
  end
end
