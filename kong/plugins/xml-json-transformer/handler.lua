-- Grab pluginname from module name
local plugin_name = "xml-json-transformer"
local cjson = require "cjson"
local table_concat = table.concat
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")
local parser = xml2lua.parser(handler)
local kong_meta = require "kong.meta"
-- create a new Lua table to hold the plugin implementation
local xml_json_transformer = {}

-- constructor
function xml_json_transformer:new()
    -- create a new instance of the plugin table
    local instance = {
        plugin_name = plugin_name
    }
    setmetatable(instance, {
        __index = self
    })
    return instance
end

function xml_json_transformer:header_filter(conf)
    -- setting the content type to application/json
    ngx.header["content-type"] = "application/json"
       -- removing content-length header to allow dynamic response size
        ngx.header["content-length"] = nil
    end

    local function xmlToJson(xmlString)
        local tree = handler:new()
        local parser = xml2lua.parser(tree)
        parser:parse(xmlString)
        -- local root = parser.root
        if tree.root.xml then
          jsonres = tree.root.xml
        else
          jsonres = tree.root
        end
            local jsonString = cjson.encode(jsonres)

            return jsonString
        end

        function xml_json_transformer:body_filter(conf)
            -- Body filter phase: code here will execute on the response body from the upstream service
            local chunk = ngx.arg[1]
            local eof = ngx.arg[2]

            -- Check if the chunk is not nil and not empty
            if chunk and chunk ~= "" then
                -- If the body is not yet collected, initialize it as an empty string
                ngx.ctx.buffer = ngx.ctx.buffer or ""
                ngx.ctx.buffer = ngx.ctx.buffer .. chunk
            end

    -- If it's the last chunk of the response body
    if eof then
        local xmlString = ngx.ctx.buffer
        -- Convert XML to JSON
        if xmlString then
            local jsonResponse = xmlToJson(xmlString)

            ngx.arg[1] = jsonResponse
         -- Membersihkan buffer setelah respons selesai diproses
            ngx.ctx.buffer = nil
        end
    else
        -- If it's not the last chunk, set the response body to an empty string
        ngx.arg[1] = ""
    end
end
-- set the plugin priority
xml_json_transformer.PRIORITY = 990
xml_json_transformer.VERSION = kong_meta.version
-- return our plugin table
return xml_json_transformer