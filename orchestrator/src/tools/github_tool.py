"""
GitHub Tool - Quản lý repositories
"""

import os
from github import Github
from typing import Dict, Any, List

_github_client = None

def get_github_client():
    """Get GitHub client singleton"""
    global _github_client
    if _github_client is None:
        token = os.getenv("GITHUB_TOKEN")
        if not token:
            raise ValueError("GITHUB_TOKEN not configured")
        _github_client = Github(token)
    return _github_client

async def create_repo(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Tạo repository trên GitHub"""
    try:
        github = get_github_client()
        user = github.get_user()
        
        name = parameters.get("name")
        description = parameters.get("description", "")
        private = parameters.get("private", False)
        
        if not name:
            raise ValueError("Repository name is required")
        
        # Create repository
        repo = user.create_repo(
            name=name,
            description=description,
            private=private
        )
        
        return {
            "success": True,
            "message": f"Repository '{name}' created successfully",
            "repo_url": repo.html_url,
            "repo_name": repo.full_name
        }
    except Exception as e:
        raise Exception(f"Failed to create repository: {str(e)}")

async def list_repos(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Liệt kê repositories"""
    try:
        github = get_github_client()
        user = github.get_user()
        
        repos = []
        for repo in user.get_repos():
            repos.append({
                "name": repo.name,
                "full_name": repo.full_name,
                "description": repo.description,
                "url": repo.html_url,
                "private": repo.private,
                "stars": repo.stargazers_count,
                "forks": repo.forks_count
            })
        
        return {
            "success": True,
            "count": len(repos),
            "repos": repos
        }
    except Exception as e:
        raise Exception(f"Failed to list repositories: {str(e)}")
