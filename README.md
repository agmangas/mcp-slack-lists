# Slack Lists MCP Server

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.10%2B-blue.svg)](https://www.python.org/)
[![MCP Version](https://img.shields.io/badge/MCP-1.2.0%2B-brightgreen.svg)](https://modelcontextprotocol.io/)

**Connect AI assistants to Slack Lists for seamless task and project management through natural language.**

Enable Claude, Cursor, and GitHub Copilot to create, update, filter, and export Slack List items directly from your conversations. Built with Python and FastMCP for production reliability.




## Features

- **CRUD Operations**: Create, read, update, and delete list items (single or bulk)
- **Advanced Filtering**: Search by any field value (status, assignee, priority, etc.)
- **Data Export**: Export to JSON or CSV for analysis and backup
- **Subtask Support**: Create hierarchical item relationships
- **Full Field Types**: Text, date, user, select, checkbox, number, email, phone
- **Rate Limiting**: Built-in protection for Slack API limits (~50 req/min)
- **Production Ready**: Comprehensive error handling, logging, and configuration




## Quick Start

### Prerequisites

- Python 3.10+
- Slack workspace with app installation permissions
- Slack bot token with `lists:read` and `lists:write` scopes

### 1. Create a Slack App

1. Go to the [Slack API website](https://api.slack.com/apps) and click **Create New App**.
2. Choose "From scratch", give your app a name (e.g., "Lists MCP Server"), and select your workspace.
3. In the app settings, go to **OAuth & Permissions**.
4. Under **Bot Token Scopes**, add the following scopes:
   - `lists:read`
   - `lists:write`
5. Click **Install to Workspace** at the top of the page and authorize the app.
6. Copy the **Bot User OAuth Token** (it starts with `xoxb-`). This is your `SLACK_BOT_TOKEN`.

### 2. Install

Choose one of the following installation methods:

#### Option A: Install from Source

```bash
git clone https://github.com/your-org/slack-lists-mcp-server.git
cd slack-lists-mcp-server
uv sync
```

#### Option B: Use Docker (Recommended for Production)

Pull the pre-built image from GitHub Container Registry:

```bash
docker pull ghcr.io/agmangas/mcp-slack-lists:latest
```

Or build locally:

```bash
git clone https://github.com/your-org/slack-lists-mcp-server.git
cd slack-lists-mcp-server
docker build -t slack-lists-mcp:local .
```

### 3. Configure

```bash
cp .env.example .env
# Edit .env and set: SLACK_BOT_TOKEN=xoxb-your-token-here
```

### 4. Test Locally

#### Using Python Directly

```bash
python src/slack_lists_server.py
```

#### Using Docker

```bash
# Run with environment variable
docker run -e SLACK_BOT_TOKEN=xoxb-your-token-here ghcr.io/agmangas/mcp-slack-lists:latest

# Or run with environment file
docker run --env-file .env ghcr.io/agmangas/mcp-slack-lists:latest
```

### 5. Connect to MCP Client

Configure your AI assistant to use the server. You can use either Python directly or Docker.

<details>
<summary><b>Claude Desktop</b></summary>

**Config File Location:**
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`

**Configuration (Python):**

```json
{
  "mcpServers": {
    "slack-lists": {
      "command": "/path/to/.venv/bin/python",
      "args": ["/path/to/src/slack_lists_server.py"],
      "env": { "SLACK_BOT_TOKEN": "xoxb-..." }
    }
  }
}
```

**Configuration (Docker):**

```json
{
  "mcpServers": {
    "slack-lists": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "SLACK_BOT_TOKEN=xoxb-...",
        "ghcr.io/agmangas/mcp-slack-lists:latest"
      ]
    }
  }
}
```

Fully restart Claude Desktop after saving.
</details>

<details>
<summary><b>Claude Code (CLI)</b></summary>

**Quick Install:**

```bash
claude mcp add slack-lists -s user -- /path/to/.venv/bin/python /path/to/src/slack_lists_server.py
claude mcp list  # Verify
```

**Or edit config** (`~/.claude.json` on Unix, `%USERPROFILE%\.claude.json` on Windows):

```json
{
  "mcpServers": {
    "slack-lists": {
      "type": "stdio",
      "command": "/path/to/.venv/bin/python",
      "args": ["/path/to/src/slack_lists_server.py"],
      "env": { "SLACK_BOT_TOKEN": "xoxb-..." }
    }
  }
}
```
</details>

<details>
<summary><b>Cursor IDE</b></summary>

**Settings → Tools & MCP → Edit Config** or edit directly:
- macOS: `~/.cursor/mcp.json`
- Windows: `%APPDATA%\Cursor\mcp.json`
- Linux: `~/.config/cursor/mcp.json`

**Configuration (Python):**

```json
{
  "mcpServers": {
    "slack-lists": {
      "command": "/path/to/.venv/bin/python",
      "args": ["/path/to/src/slack_lists_server.py"],
      "env": { "SLACK_BOT_TOKEN": "xoxb-..." }
    }
  }
}
```

**Configuration (Docker):**

```json
{
  "mcpServers": {
    "slack-lists": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "SLACK_BOT_TOKEN=xoxb-...",
        "ghcr.io/agmangas/mcp-slack-lists:latest"
      ]
    }
  }
}
```

Test with Ctrl+L: "List my Slack lists."
</details>

<details>
<summary><b>GitHub Copilot CLI</b></summary>

**Interactive Setup:**
```bash
copilot
/mcp add slack-lists
/mcp show  # Verify
```

**Or edit config:**
- User: `~/.copilot/mcp-config.json`
- Repository: `.copilot/mcp-config.json` (for teams)

```json
{
  "mcpServers": {
    "slack-lists": {
      "type": "stdio",
      "command": "/path/to/.venv/bin/python",
      "args": ["/path/to/src/slack_lists_server.py"],
      "env": { "SLACK_BOT_TOKEN": "xoxb-..." }
    }
  }
}
```

**Team Setup:** Commit `.copilot/mcp-config.json` and add to `.gitignore`:
```
.copilot/logs/
.copilot/config.json
```
</details>

---

**Configuration Tips:**
- Use absolute paths: find with `which python` (Unix) or `where python` (Windows)
- Validate JSON syntax (no trailing commas!)
- Fully restart your MCP client after changes

---

## Docker Usage

### Pulling from GitHub Container Registry

The server is automatically built and published to GHCR on every commit to main:

```bash
# Pull the latest version
docker pull ghcr.io/agmangas/mcp-slack-lists:latest

# Pull a specific version by SHA
docker pull ghcr.io/agmangas/mcp-slack-lists:sha-abc1234
```

### Running the Container

```bash
# Basic usage with environment variable
docker run -i --rm \
  -e SLACK_BOT_TOKEN=xoxb-your-token-here \
  ghcr.io/agmangas/mcp-slack-lists:latest

# Using an environment file
docker run -i --rm \
  --env-file .env \
  ghcr.io/agmangas/mcp-slack-lists:latest
```

**Important Flags:**
- `-i` (interactive): **Required** for MCP stdio communication - keeps stdin open
- `--rm`: Automatically remove container when it exits
- `-e`: Pass environment variables
- `--env-file`: Load environment variables from file

**Note**: Do NOT use `-t` (TTY) flag as it interferes with MCP's JSON-RPC stdio protocol.

### Building Locally

```bash
# Clone the repository
git clone https://github.com/agmangas/mcp-slack-lists.git
cd mcp-slack-lists

# Build the image
docker build -t slack-lists-mcp:local .

# Run your local build
docker run -i --rm \
  -e SLACK_BOT_TOKEN=xoxb-your-token-here \
  slack-lists-mcp:local
```

### Docker Compose Example

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  slack-lists-mcp:
    image: ghcr.io/agmangas/mcp-slack-lists:latest
    stdin_open: true
    environment:
      - SLACK_BOT_TOKEN=${SLACK_BOT_TOKEN}
    # Or use env_file:
    # env_file: .env
```

Run with: `docker-compose run --rm slack-lists-mcp`

### Security Notes

- **Never commit your SLACK_BOT_TOKEN** to version control
- Always use environment variables or Docker secrets for sensitive data
- The container runs as a non-root user (UID 1000) for security
- Image size: ~246MB (optimized multi-stage build)




## Available Tools

### `create_list_item`

Create a single item in a Slack List.

**Parameters:**
- `list_id` (required) - Slack List ID (e.g., `F1234ABCD`)
- `title` (required) - Item title
- `additional_fields` (optional) - JSON string of fields ([format](#field-formats))
- `parent_item_id` (optional) - Parent item ID for subtasks

### `create_multiple_list_items`

Bulk create items with rate limiting (~50 req/min).

- `list_id` (required)
- `items_data` (required) - JSON array ([format](#bulk-creation-format))
- `rate_limit_delay` (optional) - Delay in seconds (default: 1.2)

### `update_list_item`

Update a single item (partial updates supported).

- `list_id` (required)
- `item_id` (required)
- `fields` (required) - JSON string of fields to update

### `update_multiple_list_items`

Bulk update items with rate limiting.

- `list_id` (required)
- `items_data` (required) - JSON array ([format](#bulk-update-format))
- `rate_limit_delay` (optional) - Default: 1.2s

### `get_list_items`

Retrieve items with optional metadata.

- `list_id` (required)
- `limit` (optional) - Max items (default: 50, max: 100)
- `include_metadata` (optional) - Include timestamps (default: true)

### `filter_list_items`

Search items by field values.

- `list_id` (required)
- `filter_column_id` (required)
- `filter_value` (required)
- `filter_operator` (optional) - See [operators](#filter-operators)
- `max_items` (optional) - Default: 100

### `export_list_items`

Export to JSON or CSV.

- `list_id` (required)
- `export_format` (optional) - `json` or `csv` (default: json)
- `filter_column_id`, `filter_value`, `filter_operator` (optional) - For filtered exports




## Data Formats

### Field Formats

Each field requires `column_id`, `type`, and `value`:

```json
[
  {
    "column_id": "Col10000001",
    "type": "date",
    "value": "2024-12-31"
  },
  {
    "column_id": "Col10000002",
    "type": "select",
    "value": ["OptionID123"]
  },
  {
    "column_id": "Col10000003",
    "type": "user",
    "value": ["U1234567", "U2345678"]
  },
  {
    "column_id": "Col10000004",
    "type": "checkbox",
    "value": true
  }
]
```

**Supported Types:** `text`, `date` (YYYY-MM-DD), `user` (array of IDs), `select` (array of option IDs), `checkbox` (boolean), `number`, `email`, `phone`

### Bulk Creation Format

```json
[
  {
    "title": "First Task",
    "fields": [
      {"column_id": "Col123", "type": "date", "value": "2024-12-15"}
    ]
  },
  {
    "title": "Second Task",
    "fields": [
      {"column_id": "Col123", "type": "date", "value": "2024-12-20"},
      {"column_id": "Col456", "type": "user", "value": ["U1234567"]}
    ]
  }
]
```

### Bulk Update Format

```json
[
  {
    "item_id": "ITEM123",
    "fields": [
      {"column_id": "Col10000001", "type": "text", "value": "Updated status"}
    ]
  },
  {
    "item_id": "ITEM456",
    "fields": [
      {"column_id": "Col10000002", "type": "checkbox", "value": true},
      {"column_id": "Col10000003", "type": "date", "value": "2024-12-31"}
    ]
  }
]
```

### Filter Operators

- `contains` - Case-insensitive substring match
- `equals` - Exact match (case-insensitive)
- `not_equals` - Does not match
- `not_contains` - Does not contain substring
- `exists` - Has any non-empty value
- `not_exists` - Empty or missing




## Finding IDs

- **List ID**: Last segment of Slack URL (`https://app.slack.com/client/.../F1234ABCD`)
- **Column ID**: Use `get_list_items` and inspect output, or check browser DevTools network requests
- **Item ID**: Use `get_list_items` to retrieve item IDs

## Troubleshooting

| Error                 | Solution                                               |
| --------------------- | ------------------------------------------------------ |
| `invalid_auth`        | Regenerate bot token and update `.env`                 |
| `missing_scope`       | Add `lists:read` and `lists:write` scopes to Slack app |
| `list_not_found`      | Verify list ID in Slack URL                            |
| Server not responding | Check paths in config, validate JSON syntax            |
| JSON errors           | Use online validator, ensure no trailing commas        |

## Example Prompts

- "Create a task 'Implement feature X' in list F1234ABCD, assign to @john, due next Friday"
- "Show all high-priority tasks that are overdue"
- "Update item ITEM123 status to 'Complete' and set completion date to today"
- "Find all items assigned to @sarah with status 'Blocked'"
- "Export all completed tasks from list F1234 to CSV"
- "Add 5 tasks to my project list with these details: [...]"

## Contributing

Contributions are welcome! If you have ideas for new features, bug fixes, or improvements, please open an issue or submit a pull request. See `CONTRIBUTING.md` for more details.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


