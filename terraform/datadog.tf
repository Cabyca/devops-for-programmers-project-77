resource "datadog_monitor" "http_check" {
  name               = "Name for monitor foo"
  type               = "service check"
  message            = "Monitor triggered"
  escalation_message = "Escalation message"

  query = <<EOQ
  "http.can_connect".over("instance:wiki_js","url:http:localhost").by("*").last(3).count_by_status()
  EOQ
  
  monitor_thresholds {
    warning  = 1
    critical = 2
  }
}