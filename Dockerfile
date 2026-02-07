# Multi-stage Dockerfile for Slack Lists MCP Server
# Optimized for minimal size and security

# ============================================================================
# Build Stage: Install dependencies using uv
# ============================================================================
FROM python:3.10-slim AS builder

# Install uv - fast Python package installer
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Set working directory
WORKDIR /build

# Copy dependency files first for better layer caching
COPY pyproject.toml uv.lock LICENSE README.md ./

# Install dependencies into a virtual environment
# uv is much faster than pip and handles the lock file efficiently
RUN uv sync --frozen --no-dev --no-cache

# ============================================================================
# Runtime Stage: Minimal Python environment
# ============================================================================
FROM python:3.10-slim

# Add metadata labels
LABEL org.opencontainers.image.title="Slack Lists MCP Server" \
      org.opencontainers.image.description="A Model Context Protocol server for Slack Lists integration" \
      org.opencontainers.image.vendor="MCP Slack Lists Server" \
      org.opencontainers.image.source="https://github.com/agmangas/mcp-slack-lists" \
      org.opencontainers.image.licenses="MIT"

# Create non-root user for security
RUN groupadd -r mcp && useradd -r -g mcp -u 1000 mcp

# Set working directory
WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder --chown=mcp:mcp /build/.venv /app/.venv

# Copy application source code
COPY --chown=mcp:mcp src/ /app/src/

# Set up Python path to use the virtual environment
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Switch to non-root user
USER mcp

# MCP servers communicate via stdio (stdin/stdout)
# No EXPOSE directive needed - this is not a network service

# Default command runs the MCP server
# The SLACK_BOT_TOKEN must be provided via environment variable at runtime
ENTRYPOINT ["python", "/app/src/slack_lists_server.py"]
