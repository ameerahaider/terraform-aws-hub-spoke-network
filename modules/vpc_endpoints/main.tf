# ------------------------------------------------------------------------------
# Create Security Group and Interface VPC Endpoint for AWS Systems Manager (SSM)
# Service: com.amazonaws.<region>.ssm
# Allows HTTPS (port 443) access from within the VPC CIDR
# ------------------------------------------------------------------------------
resource "aws_security_group" "ssm" {
  name        = "${var.name}-ssm-endpoint-sg"
  description = "Allow HTTPS from VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name        = "${var.name}-ssm-endpoint-sg"
    Environment = var.environment
  })
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnets_ids
  security_group_ids  = [aws_security_group.ssm.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name        = "${var.vpc_name}-ssm-endpoint"
    Environment = var.environment
  })
}

# ------------------------------------------------------------------------------
# Create Security Group and Interface VPC Endpoint for SSM Messages
# Service: com.amazonaws.<region>.ssmmessages
# ------------------------------------------------------------------------------
resource "aws_security_group" "ssmmessages" {
  name        = "${var.name}-ssm-messages-endpoint-sg"
  description = "Allow HTTPS from VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name        = "${var.name}-ssm-messages-endpoint-sg"
    Environment = var.environment
  })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnets_ids
  security_group_ids  = [aws_security_group.ssmmessages.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name        = "${var.vpc_name}-ssm-message-endpoint"
    Environment = var.environment
  })
}

# ------------------------------------------------------------------------------
# Create Security Group and Interface VPC Endpoint for EC2 Messages
# Service: com.amazonaws.<region>.ec2messages
# ------------------------------------------------------------------------------
resource "aws_security_group" "ec2messages" {
  name        = "${var.name}-ec2-messages-endpoint-sg"
  description = "Allow HTTPS from VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name        = "${var.name}-ec2-messages-endpoint-sg"
    Environment = var.environment
  })
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnets_ids
  security_group_ids  = [aws_security_group.ec2messages.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name        = "${var.vpc_name}-ec2-message-endpoint"
    Environment = var.environment
  })
}
