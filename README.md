# Hello PHP - Docker Test Project

PHP 7.2 + Apache web application with CakePHP, MySQL, and Redis for AWS ECS (Fargate) deployment.

## Tech Stack

- **PHP**: 7.2 with Apache
- **Framework**: CakePHP 3.8
- **Database**: MySQL 5.7
- **Cache**: Redis 5
- **Container**: Docker & Docker Compose
- **Target Platform**: AWS ECS (Fargate)

## Project Structure

```
hello_php/
├── Dockerfile                    # PHP 7.2 + Apache container
├── docker-compose.yml            # Local development with MySQL & Redis
├── apache-config.conf            # Apache virtual host configuration
├── ecs-task-definition.json     # AWS ECS Fargate task definition
└── src/
    ├── config/
    │   ├── app.default.php      # CakePHP configuration template
    │   ├── bootstrap.php        # Application bootstrap
    │   ├── bootstrap_cli.php    # CLI bootstrap
    │   └── paths.php            # Path definitions
    ├── webroot/
    │   ├── index.php            # CakePHP entry point
    │   └── info.php             # Test page for PHP/Redis/MySQL
    ├── src/                     # Application source code
    ├── .htaccess                # URL rewriting
    └── composer.json            # PHP dependencies
```

## Quick Start (Local Development)

### Prerequisites

- Docker
- Docker Compose

### Setup and Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/okra-seiji-guthub/hello_php.git
   cd hello_php
   ```

2. **Start the containers**
   ```bash
   docker-compose up -d
   ```

3. **Install PHP dependencies**
   ```bash
   docker-compose exec web composer install
   ```

4. **Create the configuration file**
   ```bash
   docker-compose exec web cp config/app.default.php config/app.php
   ```

5. **Access the application**
   - Main app: http://localhost:8080
   - Test page: http://localhost:8080/info.php

### Stop the containers

```bash
docker-compose down
```

## Testing Connectivity

Visit `http://localhost:8080/info.php` to verify:
- ✓ PHP version and extensions
- ✓ MySQL connection
- ✓ Redis connection

## AWS ECS (Fargate) Deployment

### Prerequisites

- AWS CLI configured
- ECR repository created
- RDS MySQL instance
- ElastiCache Redis cluster
- ECS cluster created
- Secrets stored in AWS Secrets Manager

### Deployment Steps

1. **Build and push Docker image to ECR**
   ```bash
   # Login to ECR
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

   # Build the image
   docker build -t hello-php .

   # Tag the image
   docker tag hello-php:latest YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/hello-php:latest

   # Push to ECR
   docker push YOUR_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/hello-php:latest
   ```

2. **Update ECS task definition**
   - Edit `ecs-task-definition.json`
   - Replace placeholders:
     - `YOUR_ACCOUNT_ID` with your AWS account ID
     - `YOUR_ECR_REGISTRY` with your ECR registry URL
     - `YOUR_RDS_ENDPOINT` with your RDS endpoint
     - `YOUR_ELASTICACHE_ENDPOINT` with your ElastiCache endpoint

3. **Create secrets in AWS Secrets Manager**
   ```bash
   aws secretsmanager create-secret --name hello-php/db-password --secret-string "your-db-password"
   aws secretsmanager create-secret --name hello-php/security-salt --secret-string "$(openssl rand -base64 32)"
   ```

4. **Register task definition**
   ```bash
   aws ecs register-task-definition --cli-input-json file://ecs-task-definition.json
   ```

5. **Create or update ECS service**
   ```bash
   aws ecs create-service \
     --cluster hello-php-cluster \
     --service-name hello-php-service \
     --task-definition hello-php-task \
     --desired-count 2 \
     --launch-type FARGATE \
     --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx,subnet-yyy],securityGroups=[sg-xxx],assignPublicIp=ENABLED}" \
     --load-balancers "targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=hello-php-web,containerPort=80"
   ```

## Environment Variables

### Local Development (docker-compose.yml)

- `DB_HOST`: MySQL host (default: mysql)
- `DB_NAME`: Database name (default: hello_php)
- `DB_USER`: Database user (default: root)
- `DB_PASSWORD`: Database password (default: secret)
- `REDIS_HOST`: Redis host (default: redis)
- `REDIS_PORT`: Redis port (default: 6379)

### Production (ECS)

Configure in `ecs-task-definition.json`:
- Database connection via RDS endpoint
- Redis connection via ElastiCache endpoint
- Sensitive data via AWS Secrets Manager

## CakePHP Configuration

The application uses CakePHP 3.8. Configuration is in `src/config/app.php`:

- Database: Automatically configured from environment variables
- Debug mode: Set via `DEBUG` env var (true/false)
- Security salt: Set via `SECURITY_SALT` env var

## Troubleshooting

### Container Issues

```bash
# View logs
docker-compose logs web
docker-compose logs mysql
docker-compose logs redis

# Access container shell
docker-compose exec web bash
```

### Database Connection

```bash
# Connect to MySQL
docker-compose exec mysql mysql -u root -psecret hello_php
```

### Redis Connection

```bash
# Connect to Redis CLI
docker-compose exec redis redis-cli
```

## Security Notes

- Change default passwords in production
- Use AWS Secrets Manager for sensitive data in ECS
- Enable HTTPS with Application Load Balancer
- Configure security groups to restrict access
- Keep PHP and dependencies updated

## License

MIT License - see LICENSE file for details
