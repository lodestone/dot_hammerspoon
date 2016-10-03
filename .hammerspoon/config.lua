-- copy this file to config.lua and edit as needed
--
local cfg = {}
cfg.global = {}  -- this will be accessible via hsm.cfg in modules
----------------------------------------------------------------------------

local ufile = require('utils.file')
local E = require('hs.application.watcher')   -- appwindows events
local A = require('appactions')               -- appwindows actions

-- Monospace font used in multiple modules
local MONOFONT = 'Eco Coding'

--------------------
--  global paths  --
--------------------
cfg.global.paths = {}
cfg.global.paths.base  = os.getenv('HOME')
cfg.global.paths.tmp   = os.getenv('TMPDIR')
cfg.global.paths.bin   = ufile.toPath(cfg.global.paths.base, '.bin')
cfg.global.paths.cloud = ufile.toPath(cfg.global.paths.base, '=/Cloud/Dropbox')
cfg.global.paths.hs    = ufile.toPath(cfg.global.paths.base, '.hammerspoon')
cfg.global.paths.data  = ufile.toPath(cfg.global.paths.base,   '=/Cabinet/data')
cfg.global.paths.media = ufile.toPath(cfg.global.paths.base,   '=/Media')
cfg.global.paths.ul    = '/usr/local'
cfg.global.paths.ulbin = ufile.toPath(cfg.global.paths.ul,   'bin')

------------------
--  appwindows  --
------------------
-- Each app name points to a list of rules, which are event/action pairs.
-- See hs.application.watcher for events, and appactions.lua for actions.
cfg.appwindows = {
  rules = {
    Finder              = {{evt = E.activated,    act = A.toFront}},
    ['Google Chrome']   = {{evt = E.launched,     act = A.maximize}},
    Skype               = {{evt = E.launched,     act = A.fullscreen}},
  },
}

---------------
--  battery  --
---------------
cfg.battery = {
  icon = ufile.toPath(cfg.global.paths.media, 'battery.png'),
}

---------------
--  browser  --
---------------
cfg.browser = {
  apps = {
    ['com.apple.Safari'] = true,
    ['com.google.Chrome'] = true,
    ['org.mozilla.firefox'] = true,
  },
}

cfg.browser.defaultApp = 'com.apple.Safari'

----------------
--  caffeine  --
----------------
cfg.caffeine = {
  menupriority = 1390,            -- menubar priority (lower is lefter)
  notifyMinsActive = 30,          -- notify when active for this many minutes
  icons = {
    on  = ufile.toPath(cfg.global.paths.media, 'caffeine-on.pdf'),
    off = ufile.toPath(cfg.global.paths.media, 'caffeine-off.pdf'),
  },
}

------------------
--  cheatsheet  --
------------------
cfg.cheatsheet = {
  defaultName = 'default',
  chooserWidth = 50,
  maxParts = 3,
  path = {
    dir    = ufile.toPath(cfg.global.paths.cloud, 'cheatsheets'),
    css    = ufile.toPath(cfg.global.paths.media, 'cheatsheet.min.css'),
    pandoc = ufile.toPath(cfg.global.paths.ulbin, 'pandoc'),
  },
}

-------------
--  hazel  --
-------------
-- This module is intentionally full of code that ought to be customized,
-- so not much is configured here, and it might make more sense to just keep
-- all the configuration in modules/hazel.lua instead.
cfg.hazel = {
  path = {
    dump      = ufile.toPath(cfg.global.paths.base,  'Dump'),
    desktop   = ufile.toPath(cfg.global.paths.base,  'Desktop'),
    downloads = ufile.toPath(cfg.global.paths.base,  'Downloads'),
    documents = ufile.toPath(cfg.global.paths.base,  'Documents'),
    transfer  = ufile.toPath(cfg.global.paths.cloud, 'xfer'),
  },
  hiddenExtensions = {  -- when unhiding extensions, ignore these
    app = true,
  },
  waitTime = 10,   -- seconds to wait after file changed, before running rules
}

------------------
--  notational  --
------------------
cfg.notational = {
  titleWeight = 5,  -- title is this much more search-relevant than content
  width = 60,
  rows  = 10,
  path = {
    notes = ufile.toPath(cfg.global.paths.cloud, 'notes'),  -- the default location
    til   = ufile.toPath(cfg.global.paths.cloud, 'til'),
  }
}

------------------
--  scratchpad  --
------------------
cfg.scratchpad = {
  menupriority = 1370,            -- menubar priority (lower is lefter)
  width = 60,
  file = ufile.toPath(cfg.global.paths.cloud, 'scratchpad.md'),
}

-------------
--  songs  --
-------------
cfg.songs = {
  -- set this to the path of the track binary if you're using it
  -- trackBinary = ufile.toPath(cfg.global.paths.bin, 'track'),
  trackBinary = nil,
  -- set this to the path of the track database file if not default
  -- trackDB = ufile.toPath(cfg.global.paths.cloud, 'track.db'),
  trackDB = nil,
}

-------------
--  timer  --
-------------
cfg.timer = {
  menupriority = 1350,            -- menubar priority (lower is lefter)
  width = 28,
  defaultTime = 5*60,  -- in seconds
  volume = 1.0,
  icon  = ufile.toPath(cfg.global.paths.media, 'tidy-clock-icon.png'),
  sound = ufile.toPath(cfg.global.paths.media, 'Audio/Claptap.mp3'),
}

---------------
--  weather  --
---------------
cfg.weather = {
  menupriority = 1400,            -- menubar priority (lower is lefter)
  fetchTimeout = 120,             -- timeout for downloading weather data
  locationTimeout = 300,          -- timeout for lat/long lookup
  minPrecipProbability = 0.249,   -- minimum to show precipitation details

  api = {  -- forecast.io API config
    key = 'YOUR_API_KEY',
    maxCalls = 950,  -- forecast.io only allows 1000 per day
  },

  file     = ufile.toPath(cfg.global.paths.data,  'weather.json'),
  iconPath = ufile.toPath(cfg.global.paths.media, 'weather'),

  tempThresholds = {  -- Used for float comparisons, so +0.5 is easier
    warm        = 79.5,
    hot         = 87.5,
    tooHot      = 94.5,
    tooDamnHot  = 99.5,
    alert       = 104.5,
  },

  -- hs.styledtext styles
  styles = {
    default = {
      font  = MONOFONT,
      size  = 13,
    },
    warm = {
      font  = MONOFONT,
      size  = 13,
      color = {red=1,     green=0.96,  blue=0.737, alpha=1},
    },
    hot = {
      font  = MONOFONT,
      size  = 13,
      color = {red=1,     green=0.809, blue=0.493, alpha=1},
    },
    tooHot = {
      font  = MONOFONT,
      size  = 13,
      color = {red=0.984, green=0.612, blue=0.311, alpha=1},
    },
    tooDamnHot = {
      font  = MONOFONT,
      size  = 13,
      color = {red=0.976, green=0.249, blue=0.243, alpha=1},
    },
    alert = {
      font  = MONOFONT,
      size  = 13,
      color = {red=0.94,  green=0.087, blue=0.319, alpha=1},
    },
  }
}

------------
--  wifi  --
------------
cfg.wifi = {
  icon = ufile.toPath(cfg.global.paths.media, 'airport.png'),
}

----------------
--  worktime  --
----------------
cfg.worktime = {
  menupriority = 1380,            -- menubar priority (lower is lefter)
  awareness = {
    time = {
      chimeAfter  = 30,           -- mins
      chimeRepeat = 4,            -- seconds between repeated chimes
    },
    chime = {
      file = ufile.toPath(cfg.global.paths.media, 'bowl.wav'),
      volume = 0.4,
    },
  },
  pomodoro = {
    time = {
      work = 25,  -- mins
      rest = 5,   -- mins
    },
    chime = {
      file = ufile.toPath(cfg.global.paths.media, 'temple.mp3'),
      volume = 1.0,
    },
  },
}


----------------------------------------------------------------------------
return cfg
