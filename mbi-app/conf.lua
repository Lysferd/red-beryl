
function love.conf(t)
  t.title = "Red Beryl on "
  t.author = "M.A. Engenharia"
  t.url = "http://moritzalmeida.eng.br/"
  t.identity = "data"
  t.version = "0.10.1"
  t.console = true
  t.release = false

  t.window.width = 750 / 2
  t.window.height = 1334 / 2
  t.window.fullscreen = false
  t.window.vsync = true
  t.window.msaa = 8
  t.window.highdpi = false

  t.modules.mouse = true
  t.modules.keyboard = true
  t.modules.event = true
  t.modules.image = true
  t.modules.graphics = true
  t.modules.timer = true
end
