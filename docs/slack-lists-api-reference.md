# Slack Lists API Reference (AI-Friendly, Comprehensive)

Last verified: 2026-02-27

## Scope
Comprehensive request-parameter reference for all currently published `slackLists.*` Web API methods.

This version is generated from:
- Slack method docs (`docs.slack.dev/reference/methods/slackLists.*`)
- Slack official Node SDK request type source (`packages/web-api/src/types/request/slackLists.ts`)

## Current Method Set (12)
1. `slackLists.access.delete`
2. `slackLists.access.set`
3. `slackLists.create`
4. `slackLists.download.get`
5. `slackLists.download.start`
6. `slackLists.items.create`
7. `slackLists.items.delete`
8. `slackLists.items.deleteMultiple`
9. `slackLists.items.info`
10. `slackLists.items.list`
11. `slackLists.items.update`
12. `slackLists.update`

## Global Request Rules
- HTTP: `POST https://slack.com/api/<method>`
- Content type: `application/json` or `application/x-www-form-urlencoded`
- Auth (all methods):
  - Provide either `Authorization: Bearer <token>` header or `token` request field.
  - SDK types expose `token` as optional (`TokenOverridable`), but `token` is required when the auth header is not provided.

## Method Summary Matrix

| Method                            | Scope                    | Rate Tier                   | Required Params                                                | Optional Params                                                                                           |
| --------------------------------- | ------------------------ | --------------------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `slackLists.access.delete`        | `lists:write` (inferred) | Not visible on crawled page | `list_id`, and one of `channel_ids`/`user_ids`                 | `token*`, `channel_ids`, `user_ids`                                                                       |
| `slackLists.access.set`           | `lists:write` (inferred) | Not visible on crawled page | `list_id`, `access_level`, and one of `channel_ids`/`user_ids` | `token*`, `channel_ids`, `user_ids`                                                                       |
| `slackLists.create`               | `lists:write`            | Tier 2                      | `name`                                                         | `token*`, `description_blocks`, `schema`, `copy_from_list_id`, `include_copied_list_records`, `todo_mode` |
| `slackLists.download.get`         | `lists:read`             | Tier 4                      | `list_id`, `job_id`                                            | `token*`                                                                                                  |
| `slackLists.download.start`       | `lists:read`             | Tier 2                      | `list_id`                                                      | `token*`, `include_archived`                                                                              |
| `slackLists.items.create`         | `lists:write`            | Tier 3                      | `list_id`                                                      | `token*`, `duplicated_item_id`, `parent_item_id`, `initial_fields`                                        |
| `slackLists.items.delete`         | `lists:write`            | Tier 2                      | `list_id`, `id`                                                | `token*`                                                                                                  |
| `slackLists.items.deleteMultiple` | `lists:write`            | Tier 2                      | `list_id`, `ids`                                               | `token*`                                                                                                  |
| `slackLists.items.info`           | `lists:read`             | Tier 2                      | `list_id`, `id`                                                | `token*`, `include_is_subscribed`                                                                         |
| `slackLists.items.list`           | `lists:read`             | Tier 2                      | `list_id`                                                      | `token*`, `limit`, `cursor`, `archived`                                                                   |
| `slackLists.items.update`         | `lists:write`            | Tier 3                      | `list_id`, `cells`                                             | `token*`                                                                                                  |
| `slackLists.update`               | `lists:write`            | Tier 2                      | `id`                                                           | `token*`, `name`, `description_blocks`, `todo_mode`                                                       |

\* `token` is required when `Authorization: Bearer <token>` is not provided.

## Endpoint Parameter Reference

### `slackLists.access.delete`
Endpoint: `POST https://slack.com/api/slackLists.access.delete`

| Param         | Type       | Required      | Notes                                                              |
| ------------- | ---------- | ------------- | ------------------------------------------------------------------ |
| `token`       | `string`   | Conditionally | Required if `Authorization` header is not provided.                |
| `list_id`     | `string`   | Yes           | Encoded list ID.                                                   |
| `channel_ids` | `string[]` | Conditionally | Channels to update access for. Use only when `user_ids` is absent. |
| `user_ids`    | `string[]` | Conditionally | Users to update access for. Use only when `channel_ids` is absent. |

Constraints:
- Provide exactly one target collection: `channel_ids` or `user_ids`.

### `slackLists.access.set`
Endpoint: `POST https://slack.com/api/slackLists.access.set`

| Param          | Type       | Required      | Notes                                                              |
| -------------- | ---------- | ------------- | ------------------------------------------------------------------ |
| `token`        | `string`   | Conditionally | Required if `Authorization` header is not provided.                |
| `list_id`      | `string`   | Yes           | Encoded list ID.                                                   |
| `access_level` | `string`   | Yes           | Access level (`read`, `write`, `owner`).                           |
| `channel_ids`  | `string[]` | Conditionally | Channels to update access for. Use only when `user_ids` is absent. |
| `user_ids`     | `string[]` | Conditionally | Users to update access for. Use only when `channel_ids` is absent. |

Constraints:
- Provide exactly one target collection: `channel_ids` or `user_ids`.
- `owner` access level applies to users (not channels).

### `slackLists.create`
Endpoint: `POST https://slack.com/api/slackLists.create`

| Param                         | Type                       | Required      | Notes                                               |
| ----------------------------- | -------------------------- | ------------- | --------------------------------------------------- |
| `token`                       | `string`                   | Conditionally | Required if `Authorization` header is not provided. |
| `name`                        | `string`                   | Yes           | List name.                                          |
| `description_blocks`          | `RichTextBlock[]`          | No            | Rich text description.                              |
| `schema`                      | `SlackListsSchemaColumn[]` | No            | Column definition. See shared types.                |
| `copy_from_list_id`           | `string`                   | No            | Source list ID when copying.                        |
| `include_copied_list_records` | `boolean`                  | No            | Include records when copying list.                  |
| `todo_mode`                   | `boolean`                  | No            | Enables task-tracking semantics.                    |

### `slackLists.download.get`
Endpoint: `POST https://slack.com/api/slackLists.download.get`

| Param     | Type     | Required      | Notes                                               |
| --------- | -------- | ------------- | --------------------------------------------------- |
| `token`   | `string` | Conditionally | Required if `Authorization` header is not provided. |
| `list_id` | `string` | Yes           | Encoded list ID.                                    |
| `job_id`  | `string` | Yes           | Export job ID from `slackLists.download.start`.     |

### `slackLists.download.start`
Endpoint: `POST https://slack.com/api/slackLists.download.start`

| Param              | Type      | Required      | Notes                                               |
| ------------------ | --------- | ------------- | --------------------------------------------------- |
| `token`            | `string`  | Conditionally | Required if `Authorization` header is not provided. |
| `list_id`          | `string`  | Yes           | Encoded list ID.                                    |
| `include_archived` | `boolean` | No            | Include archived items in export.                   |

### `slackLists.items.create`
Endpoint: `POST https://slack.com/api/slackLists.items.create`

| Param                | Type                    | Required      | Notes                                               |
| -------------------- | ----------------------- | ------------- | --------------------------------------------------- |
| `token`              | `string`                | Conditionally | Required if `Authorization` header is not provided. |
| `list_id`            | `string`                | Yes           | Encoded list ID.                                    |
| `duplicated_item_id` | `string`                | No            | Row ID to duplicate.                                |
| `parent_item_id`     | `string`                | No            | Parent row ID when creating a subtask.              |
| `initial_fields`     | `SlackListsItemField[]` | No            | Initial cell values. See shared field union type.   |

### `slackLists.items.delete`
Endpoint: `POST https://slack.com/api/slackLists.items.delete`

| Param     | Type     | Required      | Notes                                               |
| --------- | -------- | ------------- | --------------------------------------------------- |
| `token`   | `string` | Conditionally | Required if `Authorization` header is not provided. |
| `list_id` | `string` | Yes           | Encoded list ID.                                    |
| `id`      | `string` | Yes           | Item/row ID to delete.                              |

### `slackLists.items.deleteMultiple`
Endpoint: `POST https://slack.com/api/slackLists.items.deleteMultiple`

| Param     | Type       | Required      | Notes                                               |
| --------- | ---------- | ------------- | --------------------------------------------------- |
| `token`   | `string`   | Conditionally | Required if `Authorization` header is not provided. |
| `list_id` | `string`   | Yes           | Encoded list ID.                                    |
| `ids`     | `string[]` | Yes           | Item/row IDs to delete.                             |

### `slackLists.items.info`
Endpoint: `POST https://slack.com/api/slackLists.items.info`

| Param                   | Type      | Required      | Notes                                               |
| ----------------------- | --------- | ------------- | --------------------------------------------------- |
| `token`                 | `string`  | Conditionally | Required if `Authorization` header is not provided. |
| `list_id`               | `string`  | Yes           | Encoded list ID.                                    |
| `id`                    | `string`  | Yes           | Item/row ID to fetch.                               |
| `include_is_subscribed` | `boolean` | No            | Include row subscription flag in response.          |

### `slackLists.items.list`
Endpoint: `POST https://slack.com/api/slackLists.items.list`

| Param      | Type      | Required      | Notes                                                  |
| ---------- | --------- | ------------- | ------------------------------------------------------ |
| `token`    | `string`  | Conditionally | Required if `Authorization` header is not provided.    |
| `list_id`  | `string`  | Yes           | Encoded list ID.                                       |
| `limit`    | `number`  | No            | Max records returned.                                  |
| `cursor`   | `string`  | No            | Next cursor for pagination.                            |
| `archived` | `boolean` | No            | `true` returns archived items; otherwise active items. |

### `slackLists.items.update`
Endpoint: `POST https://slack.com/api/slackLists.items.update`

| Param     | Type                         | Required      | Notes                                                                         |
| --------- | ---------------------------- | ------------- | ----------------------------------------------------------------------------- |
| `token`   | `string`                     | Conditionally | Required if `Authorization` header is not provided.                           |
| `list_id` | `string`                     | Yes           | Encoded list ID.                                                              |
| `cells`   | `SlackListsItemCellUpdate[]` | Yes           | Cell updates; each includes `row_id`, `column_id`, and one typed field value. |

### `slackLists.update`
Endpoint: `POST https://slack.com/api/slackLists.update`

| Param                | Type              | Required      | Notes                                               |
| -------------------- | ----------------- | ------------- | --------------------------------------------------- |
| `token`              | `string`          | Conditionally | Required if `Authorization` header is not provided. |
| `id`                 | `string`          | Yes           | Encoded list ID.                                    |
| `name`               | `string`          | No            | List name.                                          |
| `description_blocks` | `RichTextBlock[]` | No            | Rich text description.                              |
| `todo_mode`          | `boolean`         | No            | Enables/disables task-tracking behavior.            |

## Shared Complex Types

### `SlackListsItemField` (for `initial_fields` and `cells`)
Each field object must include `column_id` plus exactly one typed value key.

| Field Variant Key | Value Type                                                                       |
| ----------------- | -------------------------------------------------------------------------------- |
| `attachment`      | `string[]`                                                                       |
| `channel`         | `string[]`                                                                       |
| `checkbox`        | `boolean`                                                                        |
| `date`            | `string[]` (`YYYY-MM-DD`)                                                        |
| `email`           | `string[]`                                                                       |
| `link`            | `Array<{ original_url: string; display_as_url: boolean; display_name: string }>` |
| `message`         | `string[]`                                                                       |
| `number`          | `number[]`                                                                       |
| `phone`           | `string[]`                                                                       |
| `rating`          | `number[]`                                                                       |
| `reference`       | `Array<{ file: { file_id: string } }>`                                           |
| `rich_text`       | `RichTextBlock[]`                                                                |
| `select`          | `string[]`                                                                       |
| `timestamp`       | `number[]`                                                                       |
| `user`            | `string[]`                                                                       |

### `SlackListsItemCellUpdate`
Used by `slackLists.items.update`.

Required shape:
- `row_id: string`
- plus one `SlackListsItemField` variant (`column_id` + one typed value key)

Compatibility note:
- Slack method docs include an alternate example with `row_id_to_create: true` and a related validation message mentioning `column_id_to_create`.
- These keys are not currently represented in the official Node SDK request types, so this reference treats them as doc-only/underspecified behavior.

### `SlackListsSchemaColumn` (for `slackLists.create.schema`)

| Property            | Type                            | Required | Notes                                     |
| ------------------- | ------------------------------- | -------- | ----------------------------------------- |
| `key`               | `string`                        | Yes      | Internal column key.                      |
| `name`              | `string`                        | Yes      | Display name.                             |
| `type`              | `string`                        | Yes      | Column type identifier.                   |
| `is_primary_column` | `boolean`                       | No       | At most one primary column; must be text. |
| `options`           | `SlackListsSchemaColumnOptions` | No       | Type-specific config.                     |

### `SlackListsSchemaColumnOptions`

| Property              | Type                                 | Required | Notes                                                   |
| --------------------- | ------------------------------------ | -------- | ------------------------------------------------------- |
| `choices`             | `SlackListsSchemaColumnChoice[]`     | No       | Select options.                                         |
| `format`              | `string`                             | No       | Formatting for applicable types (for example select).   |
| `precision`           | `number`                             | No       | Numeric decimal precision.                              |
| `date_format`         | `string`                             | No       | Date display format.                                    |
| `emoji`               | `string`                             | No       | Emoji marker (rating/vote).                             |
| `emoji_team_id`       | `string`                             | No       | Team ID owning emoji.                                   |
| `max`                 | `number`                             | No       | Max rating value.                                       |
| `default_value_typed` | `SlackListsSchemaColumnDefaultValue` | No       | Default values for select/user/channel columns.         |
| `show_member_name`    | `boolean`                            | No       | Show entity name (people/channel/canvas), default true. |
| `notify_users`        | `boolean`                            | No       | Notify users on people-column updates.                  |

### `SlackListsSchemaColumnChoice`

| Property | Type     | Required |
| -------- | -------- | -------- |
| `value`  | `string` | Yes      |
| `label`  | `string` | Yes      |
| `color`  | `string` | Yes      |

### `SlackListsSchemaColumnDefaultValue`

| Property  | Type       | Required | Notes                                           |
| --------- | ---------- | -------- | ----------------------------------------------- |
| `user`    | `string[]` | No       | Default encoded user IDs for people column.     |
| `channel` | `string[]` | No       | Default encoded channel IDs for channel column. |
| `select`  | `string[]` | No       | Default option values for select column.        |

## AI-Consumable YAML

```yaml
slack_lists_api:
  version_checked_at: "2026-02-27"
  auth:
    one_of: [authorization_header, token]
    note: "token is required when Authorization header is absent"
  methods:
    - method: slackLists.access.delete
      required: [list_id]
      conditional_required:
        one_of: [channel_ids, user_ids]
      optional: [token, channel_ids, user_ids]
    - method: slackLists.access.set
      required: [list_id, access_level]
      conditional_required:
        one_of: [channel_ids, user_ids]
      optional: [token, channel_ids, user_ids]
      access_level_values: [read, write, owner]
    - method: slackLists.create
      required: [name]
      optional: [token, description_blocks, schema, copy_from_list_id, include_copied_list_records, todo_mode]
    - method: slackLists.download.get
      required: [list_id, job_id]
      optional: [token]
    - method: slackLists.download.start
      required: [list_id]
      optional: [token, include_archived]
    - method: slackLists.items.create
      required: [list_id]
      optional: [token, duplicated_item_id, parent_item_id, initial_fields]
    - method: slackLists.items.delete
      required: [list_id, id]
      optional: [token]
    - method: slackLists.items.deleteMultiple
      required: [list_id, ids]
      optional: [token]
    - method: slackLists.items.info
      required: [list_id, id]
      optional: [token, include_is_subscribed]
    - method: slackLists.items.list
      required: [list_id]
      optional: [token, limit, cursor, archived]
    - method: slackLists.items.update
      required: [list_id, cells]
      optional: [token]
    - method: slackLists.update
      required: [id]
      optional: [token, name, description_blocks, todo_mode]
```

## Sources
- https://docs.slack.dev/reference/methods/slackLists.access.delete/
- https://docs.slack.dev/reference/methods/slackLists.access.set/
- https://docs.slack.dev/reference/methods/slackLists.create/
- https://docs.slack.dev/reference/methods/slackLists.download.get/
- https://docs.slack.dev/reference/methods/slackLists.download.start/
- https://docs.slack.dev/reference/methods/slackLists.items.create/
- https://docs.slack.dev/reference/methods/slackLists.items.delete/
- https://docs.slack.dev/reference/methods/slackLists.items.deleteMultiple/
- https://docs.slack.dev/reference/methods/slackLists.items.info/
- https://docs.slack.dev/reference/methods/slackLists.items.list/
- https://docs.slack.dev/reference/methods/slackLists.items.update/
- https://docs.slack.dev/reference/methods/slackLists.update/
