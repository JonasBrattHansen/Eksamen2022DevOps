resource "aws_apprunner_service" "service" {
  service_name = var.candidate_id
  source_configuration {

    authentication_configuration {
      access_role_arn = "arn:aws:iam::244530008913:role/service-role/arn:aws:iam::244530008913:role/AppRunnerECRRole1029"
    }
    image_repository {
          image_configuration {
            port = "8080"
          }
          image_identifier      = "244530008913.dkr.ecr.eu-west-1.amazonaws.com/1029:latest"
          image_repository_type = "ECR"
        }

    auto_deployments_enabled = false
  }
}