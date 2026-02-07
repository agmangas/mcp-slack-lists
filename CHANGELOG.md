# Changelog

All notable changes to the Slack Lists MCP Server will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-06

### Fixed

- **CRITICAL**: Fixed `slackLists.items.list` using GET instead of POST ([#1](https://github.com/your-org/mcp-slack-lists/issues/1))
  - The Slack Lists API requires POST with JSON body for all methods
  - This was the root cause of persistent `invalid_arguments` errors
  - Changed from `GET /api/slackLists.items.list?list_id=...` to `POST /api/slackLists.items.list` with JSON body

- **Enhanced error messages** to include `response_metadata.messages` from Slack API
  - Users now see specific field-level error details
  - Example: `"invalid_arguments - Details: [ERROR] missing required field: list_id"`
  - Significantly improves debugging experience

- **Fixed exception double-wrapping** in error handling
  - `SlackListsError` exceptions are no longer caught and re-wrapped by generic handler
  - Error messages are now clean without redundant prefixes

### Added

- Support for creating `number`, `email`, and `phone` field types
  - Added `create_number_field()` helper function
  - Added `create_email_field()` helper function
  - Added `create_phone_field()` helper function
  - Updated both `create_list_item` and `create_multiple_list_items` tools

- Proper `main()` function entry point
  - Package can now be installed as a console script
  - Invocable via `slack-lists-mcp` command after installation

- Comprehensive test coverage for new features
  - Tests for new field creator functions
  - Tests for enhanced error message handling
  - All 21 unit tests passing

### Documentation

- Added [FIXES.md](./FIXES.md) - Detailed technical breakdown of all fixes
- Added [MIGRATION.md](./MIGRATION.md) - Upgrade guide for users
- Added CHANGELOG.md (this file)

### Technical Details

**Changed API Calls:**
```python
# Before (incorrect):
GET https://slack.com/api/slackLists.items.list?list_id=F123&limit=100

# After (correct):
POST https://slack.com/api/slackLists.items.list
Content-Type: application/json
{"list_id": "F123", "limit": 100}
```

**Affected Files:**
- `src/slack_lists_server.py` - Core server implementation
- `tests/test_server.py` - Test suite

**Test Results:**
```
21 passed, 1 skipped in 0.22s
```

## [1.0.0] - 2026-02-05

### Added

- Initial release of Slack Lists MCP Server
- Five core tools:
  - `create_list_item` - Create a single list item
  - `create_multiple_list_items` - Bulk create items with rate limiting
  - `get_list_items` - Retrieve items from a list
  - `filter_list_items` - Filter items by field values
  - `export_list_items` - Export items to JSON or CSV
- Support for all major Slack List field types:
  - Text (rich_text format)
  - Date
  - User
  - Select
  - Checkbox
- FastMCP-based implementation
- Environment variable configuration
- Comprehensive error handling
- Test suite with unit tests
- Full documentation and examples

### Known Issues

- `slackLists.items.list` uses GET instead of POST (fixed in v1.1.0)
- Missing support for number, email, phone field creation (fixed in v1.1.0)
- Error messages don't include `response_metadata.messages` (fixed in v1.1.0)

---

## Version Support

- **v1.1.0**: Recommended for all users. Fixes critical `invalid_arguments` bug.
- **v1.0.0**: Not recommended. Contains critical bug preventing list reads.

## Migration Guides

- [v1.0.0 → v1.1.0](./MIGRATION.md)

## Links

- [GitHub Repository](https://github.com/your-org/mcp-slack-lists)
- [Issue Tracker](https://github.com/your-org/mcp-slack-lists/issues)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Slack Lists API Documentation](https://docs.slack.dev/reference/methods?family=lists)
