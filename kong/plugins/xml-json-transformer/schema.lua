-- config input validation scripts


-- plugin configuration


-- return {
--   name = "xml-json-transformer",
--   no_consumer = false, -- this plugin is available on APIs as well as on Consumers,
--   fields = {
--     ignore_content_type = {type = "boolean", default = false},
--   },
-- #  self_check = function(schema, plugin_t, dao, is_updating)
--     return true
--   end,
--   -- Add plugin version

-- }

return {
  name = "xml-json-transformer",
  fields = {
    { config = {
      type = "record",
      fields = {
          { ignore_content_type = {
              description = "If true, set true.",
              type = "boolean",
              required = true,
              default = false } },
        }
      }
    },
   }
}
