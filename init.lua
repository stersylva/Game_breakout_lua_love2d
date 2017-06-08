function init_load()

end
function init_update(dt)
end

function init_draw()
  love.graphics.print("Game Breakout",screen_w/3,screen_h/10)
  love.graphics.print("J-Jogar",screen_w/3,screen_h/8)
  love.graphics.print("C-Creditos",screen_w/3,screen_h/6)
  love.graphics.print("S-Sair",screen_w/3,screen_h/4)
end

function init_keypressed(key,unicode)
  if key == "j" then
    gamestate = "game"
  elseif key == "c" then
    gamestate = "creditos"
  elseif key == "s" then
    love.event.quit()
  end
end
