#!/bin/bash

# Docker Container Killer Script
# Safely stops and removes all running Docker containers

echo "🗑️  Docker Container Killer"
echo "=========================="
echo

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running or not accessible"
    echo "Please start Docker Desktop or Docker daemon"
    exit 1
fi

# Count running containers
running_count=$(docker ps -q | wc -l | tr -d ' ')

if [ "$running_count" -eq 0 ]; then
    echo "✅ No running containers found"
    exit 0
fi

echo "📋 Currently running containers:"
echo "-------------------------------"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
echo

echo "⚠️  WARNING: This will stop and remove ALL running containers!"
echo "📊 Found $running_count running container(s)"
echo

# Ask for confirmation
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled"
    exit 0
fi

echo
echo "🔄 Stopping containers..."

# Stop all running containers
if docker stop $(docker ps -q) >/dev/null 2>&1; then
    echo "✅ All containers stopped successfully"
else
    echo "⚠️  Some containers may not have stopped properly"
fi

echo
echo "🗑️  Removing stopped containers..."

# Remove all stopped containers
if docker container prune -f >/dev/null 2>&1; then
    echo "✅ All stopped containers removed successfully"
else
    echo "⚠️  Some containers may not have been removed"
fi

echo
echo "🧹 Cleaning up unused resources..."

# Clean up unused networks, images, and volumes (optional)
read -p "Do you want to also remove unused networks, images, and volumes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️  Removing unused networks..."
    docker network prune -f >/dev/null 2>&1
    
    echo "🗑️  Removing unused images..."
    docker image prune -f >/dev/null 2>&1
    
    echo "🗑️  Removing unused volumes..."
    docker volume prune -f >/dev/null 2>&1
    
    echo "✅ Cleanup completed"
fi

echo
echo "🎉 All operations completed!"
echo "📊 Current container status:"
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | head -1
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | grep -v "NAMES" 