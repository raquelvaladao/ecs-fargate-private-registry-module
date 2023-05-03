{
    "family": "${family}",
    "taskRoleArn": "${taskRoleArn}",
    "containerDefinitions": [
        {
            "name": "${name}",
            "image": "${privateRegistryUrl}:${version}",
            "repositoryCredentials": {
                "credentialsParameter": "${secretArn}"
            },
            "cpu": 10,
            "memory": 512,
            "portMappings": [
                {
                    "containerPort": 8080,
                    "hostPort": 8080
                }
            ],
            "essential": true,
            "environment": "${environment}"
        }
    ]
}