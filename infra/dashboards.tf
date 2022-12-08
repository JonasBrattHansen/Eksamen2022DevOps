resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.candidate_id
## Jim; seriously! we can use any word here.. How cool is that?
  dashboard_body = <<DASHBOARD
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 10,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${var.candidate_id}",
            "carts_count.value"
          ]
        ],
        "period": 300,
        "stat": "Maximum",
        "region": "eu-west-1",
        "title": "Total number of carts"
      }
    },
    {
          "type": "metric",
          "x": 11,
          "y": 0,
          "width": 10,
          "height": 6,
          "properties": {
            "metrics": [
              [
                "${var.candidate_id}",
                "carts_value.value"
              ]
            ],
            "period": 300,
            "stat": "Maximum",
            "region": "eu-west-1",
            "title": "Total sum money in carts"
          }
        },
        {
                  "type": "metric",
                  "x": 0,
                  "y": 11,
                  "width": 10,
                  "height": 6,
                  "properties": {
                    "metrics": [
                      [
                        "${var.candidate_id}",
                        "checkouts.count"
                      ]
                    ],
                    "period": 900,
                    "stat": "Sum",
                    "region": "eu-west-1",
                    "title": "Total checkouts"
                  }
                },
                {
                                  "type": "metric",
                                  "x": 11,
                                  "y": 11,
                                  "width": 10,
                                  "height": 6,
                                  "properties": {
                                    "metrics": [
                                      [
                                        "${var.candidate_id}",
                                        "checkout_latency.avg"
                                      ]
                                    ],
                                    "period": 300,
                                    "stat": "Average",
                                    "region": "eu-west-1",
                                    "title": "Average responsetime for checkout"
                                  }
                                }

  ]


}
DASHBOARD
}