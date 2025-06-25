#!/bin/bash

# Docker Container Monitor Script
# Shows running Docker containers with useful information

echo "🐳 Docker Container Monitor"
echo "=========================="
echo

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running or not accessible"
    echo "Please start Docker Desktop or Docker daemon"
    exit 1
fi

# Show running containers with detailed information
echo "📋 Running Containers:"
echo "----------------------"
if docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | grep -q .; then
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
else
    echo "No running containers found"
fi

echo
echo "📊 Container Statistics:"
echo "----------------------"
if docker ps -q | grep -q .; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
else
    echo "No running containers to show statistics for"
fi

echo
echo "🔍 Container Details:"
echo "-------------------"
if docker ps -q | grep -q .; then
    for container in $(docker ps -q); do
        echo "Container: $(docker inspect --format '{{.Name}}' $container | sed 's/\///')"
        echo "  Image: $(docker inspect --format '{{.Config.Image}}' $container)"
        echo "  Created: $(docker inspect --format '{{.Created}}' $container | cut -d'T' -f1)"
        echo "  Ports: $(docker port $container 2>/dev/null || echo 'No ports exposed')"
        echo "  Status: $(docker inspect --format '{{.State.Status}}' $container)"
        echo "  Health: $(docker inspect --format '{{.State.Health.Status}}' $container 2>/dev/null || echo 'No health check')"
        echo
    done
else
    echo "No running containers found"
fi

# Show total count
running_count=$(docker ps -q | wc -l | tr -d ' ')
echo "📈 Summary: $running_count container(s) running"
echo
echo "💡 Tips:"
echo "  - Use 'docker logs <container_name>' to view logs"
echo "  - Use 'docker exec -it <container_name> /bin/bash' to enter a container"
echo "  - Use 'docker stop <container_name>' to stop a container" 