package = "kong-plugin-xml-json-transformer"
version = "0.2.0-1"
rockspec_format = "3.0"
supported_platforms = {"linux", "macosx"}
source = {
   url = "git://github.com/mrliputo/kong-plugin-xml-json-transformer"
}
description = {
   summary = "xml-json-transformer is a Kong plugin to trasnfer XML responses to JSON",
   detailed = [[
## Configuration parameters
|FORM PARAMETER|DEFAULT|DESCRIPTION|
|:----|:------:|------:|
|config.ignore_content_type|false|This parameter can be used if any traffic (not only application/xml) shall be tried to convert|
]],
   homepage = "https://github.com/mrliputo/kong-plugin-xml-json-transformer",
   license = "BSD 2-Clause License"
}
dependencies = {
   "xml2lua >= 1.4",
}

build = {
  type = "builtin",
  modules = {
    -- Mendefinisikan pluginName dengan nilai "xml-json-transformer"
    ["kong.plugins.xml-json-transformer.handler"] = "kong/plugins/xml-json-transformer/handler.lua",
    ["kong.plugins.xml-json-transformer.schema"] = "kong/plugins/xml-json-transformer/schema.lua",
  }
}
