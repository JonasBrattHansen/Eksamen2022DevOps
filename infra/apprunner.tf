resource "aws_apprunner_service" "service" {
  service_name = var.candidate_id
  source_configuration {

    authentication_configuration {
      access_role_arn = "arn:aws:iam::244530008913:role/service-role/AppRunnerECRAccessRole"
    }
    auto_deployments_enabled = false
  }
}