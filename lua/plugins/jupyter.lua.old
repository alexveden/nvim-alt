-- NOTE: see more specific Jupyter binding in after/ftplugin/python.lua
return {
  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    -- needs:
    -- pip install jupytext
    'GCBallesteros/jupytext.nvim',
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'py',
          style = 'percent',
          -- force_ft = 'python', -- you can set whatever filetype you want here
        },
      },
    },
  },
}
