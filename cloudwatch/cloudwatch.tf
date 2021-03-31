resource "aws_cloudwatch_dashboard" "ec2" {
  dashboard_name = "${var.deployment_name}-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "${var.aws_instance_id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.region}",
        "title": "EC2 Instance CPU"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "Hello world"
      }
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "ec2-logs" {
  name = "${var.deployment_name}-ec2-logs"

  tags = {
    Environment = "${var.deployment_name}"
  }
}


