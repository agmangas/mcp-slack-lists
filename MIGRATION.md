# Migration Guide

## Upgrading to v1.1.0

This release includes critical bug fixes that resolve the `invalid_arguments` error. **No changes are required** to your configuration or usage—the fixes are all internal.

### What Changed

#### 1. API Method Changes (Internal)

The `slackLists.items.list` method now correctly uses POST with a JSON body instead of GET with query parameters. This change is **transparent** to users—you don't need to modify any code.

#### 2. Enhanced Error Messages

Error messages now include detailed diagnostic information from Slack's `response_metadata.messages` field. This means you'll see more helpful error messages like:

**Before:**
```
❌ Slack Lists error: invalid_arguments
```

**After:**
```
❌ Slack Lists error: invalid_arguments - Details: [ERROR] missing required field: list_id
```

#### 3. New Field Types Supported

You can now create items with `number`, `email`, and `phone` field types:

```json
{
  "additional_fields": [
    {"column_id": "Col123", "type": "number", "value": 42.5},
    {"column_id": "Col456", "type": "email", "value": "user@example.com"},
    {"column_id": "Col789", "type": "phone", "value": "+1234567890"}
  ]
}
```

### Testing Your Upgrade

After upgrading, verify everything works:

1. **Test a simple read operation:**
   ```bash
   # Use the get_list_items tool through your MCP client
   # This should now work without invalid_arguments errors
   ```

2. **Test item creation:**
   ```bash
   # Create a test item with the create_list_item tool
   # Should complete successfully
   ```

3. **Check error messages:**
   ```bash
   # Try creating an item with invalid parameters
   # You should see detailed error messages
   ```

### Breaking Changes

**None.** This is a backward-compatible bug fix release.

### Known Issues

If you're still experiencing `invalid_arguments` errors after upgrading, check:

1. **Column IDs are valid**: Verify your `column_id` values match actual columns in your list
2. **List ID format**: Ensure your `list_id` starts with `F` (e.g., `F1234ABCD`)
3. **Bot token scopes**: Confirm your bot has both `lists:read` and `lists:write` scopes
4. **Bot added to channel**: The bot must be added to the channel where the list resides

### Getting Help

If you encounter issues:

1. Check the enhanced error messages—they now provide detailed diagnostics
2. Review the [FIXES.md](./FIXES.md) document for technical details
3. Open an issue on GitHub with:
   - The error message (including the new diagnostic details)
   - Your MCP client configuration
   - Steps to reproduce the issue

### Technical Details

For developers and contributors, see [FIXES.md](./FIXES.md) for a comprehensive breakdown of all changes, including:
- Root cause analysis of the `invalid_arguments` bug
- Implementation details of each fix
- API insights about Slack's RPC-style architecture
- Test coverage improvements
