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
  #include_tags = true

  #tags = ["foo:bar", "team:fooBar"]
}

# resource "datadog_synthetics_test" "http_check" {
#   type = "api"

#   request = {
#     method = "GET"
#     # url    = "<your-api-url>"
#     url    = "https://cabyca.ru"
#   }

#   assertions = [
#     {
#       type     = "statusCode"
#       operator = "isEqual"
#       target   = "200"
#     }
#   ]
# }

#   name    = "Terraform Synthetics Test Configuration"
#   message = "This is a test message for the synthetics check"
#   status  = "live"

#   options = {
#     tick_every = 60
#   }

#   tags = [
#     "env:prod",
#     "service:api"
#   ]
# }

#resource "datadog_monitor" "ping_monitoring" {
#   name    = "Ping service"
#   type    = "service check"
#   message = "App is not responding"

#   query = "\"http.can_connect\".over(\"instance:check_service\").by(\"*\").last(2).count_by_status()"

#   monitor_thresholds {
#     ok      = 2
#     warning = 2
#   }

# }