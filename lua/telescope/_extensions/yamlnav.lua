return require("telescope").register_extension({
  exports = {
    yamlnav = require("yamlnav").list_paths
  }
})
