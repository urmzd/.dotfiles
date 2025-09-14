local path = require("mason-core.path")
local jdtls_path = path.concat({ vim.fn.stdpath("data"), "mason", "packages", "jdtls" });
local lsp_version = "1.6.500.v20230622-2056"
local lsp_path = path.concat({ jdtls_path, "plugins", "org.eclipse.equinox.launcher_" .. lsp_version .. ".jar" })
local config_path = path.concat({ jdtls_path, "config_linux" })
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local home = vim.fn.expand("$HOME")
local workspace_dir = home .. '/.workspace/' .. project_name
local lombok_jar = path.concat({ jdtls_path, "lombok.jar" })

local java_path = home .. "/.sdkman/candidates/java/current/bin/java"

local cmd = {
   java_path,
   '-Declipse.application=org.eclipse.jdt.ls.core.id1',
   '-Dosgi.bundles.defaultStartLevel=4',
   '-Declipse.product=org.eclipse.jdt.ls.core.product',
   '-Dlog.protocol=true',
   '-Dlog.level=ALL',
   '-Xms1g',
   '--add-modules=ALL-SYSTEM',
   '--add-opens', 'java.base/java.util=ALL-UNNAMED',
   '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
   "-javaagent:" .. lombok_jar,
   "-jar", lsp_path,
   "-configuration", config_path,
   "-data", workspace_dir
}

print(vim.inspect(cmd))

local M = {
   cmd = cmd,
   settings = {
      java = {
         configuration = {
            runtimes = {
               {
                  name = "JavaSE-11",
                  path = '~/.sdkman/candidates/java/11.0.10-open',
                  default = true
               }
            }
         },
         format = {
            settings = {
               url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
               profile = "GoogleStyle"
            },
            enabled = true
         },
         trace = {
            server = "verbose"
         },
         maven = {
            downloadSources = true
         },
         import = {
            maven = {
               enabled = true
            }
         }
      }
   },
   use_lombok_agent = true
}

local config = require("lsp_config")
require("jdtls").start_or_attach(config.setup_with_coq(M))
