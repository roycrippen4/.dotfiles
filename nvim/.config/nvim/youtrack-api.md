## YouTrack.nvim

YouTrack integration in Neovim

## Api Calls I think I'll Need

[Tags](https://www.jetbrains.com/help/youtrack/devportal/resource-api-tags.html)
This resource lets you access and work with tags in YouTrack.

_Resource_

- /api/tags

_Returned entity_

- Tag. For the description of the entity attributes, see Supported Fields section.

_Supported methods_

- GET: Read a List of Tags.
- POST: Add a New Tag.

_Supported sub-resources_

- /api/tags/{tagID}: Operations with Specific Tag
- /api/tags/{tagID}/issues: Issues

_Notes_

- I think I only really need the name and id of a parcicular tag.
  Will allow me to list out all available tags to apply to a cards

## Resources

[Create an issue via API](https://www.jetbrains.com/help/youtrack/devportal/api-howto-create-issue.html#step-by-step)
