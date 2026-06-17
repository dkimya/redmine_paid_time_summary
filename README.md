# Redmine Paid Time Summary

Adds a small "Total Paid Time" box to the Redmine project overview page.

## Business Rule

For the current project, total paid time is calculated as:

```sql
SUM(time_entries.hours)
```

Only time entries linked to issues where issue custom field `72` (`Invoiced?`) has value `"1"` are counted.

Redmine boolean custom field values are handled as:

- Yes: `"1"`
- No: `"0"`
- Blank: `nil`

The plugin does not check for the string `"YES"`.

## Display

The project overview page shows:

- Paid issues count
- Total paid time rounded to 2 decimals

## Installation

Copy this directory to:

```text
redmine/plugins/redmine_paid_time_summary
```

Restart Redmine.

No database migration is required for version 1.

## Verification

From the Redmine root, after installing the plugin and restarting/reloading the app:

```bash
bin/rails runner "project = Project.find(210); summary = RedminePaidTimeSummary.for_project(project); puts \"Paid issues: #{summary.paid_issues_count}\"; puts \"Total paid time: #{format('%.2f', summary.total_paid_hours)}\""
```

## Test Case

Confirmed project:

- Project ID: `210`
- Identifier: `nwp-northwood-propane`
- Expected paid issues: `1`
- Expected total paid time: `13.37` hours
- Ticket: `#13606`
