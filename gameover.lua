function gameover_draw()
  love.graphics.print("Pontos ".. score,screen_w/3,screen_h/10)
  love.graphics.print("J-Jogar",screen_w/3,screen_h/8)
  love.graphics.print("S-Sair",screen_w/3,screen_h/6)
end

function gameover_keypressed(key,unicode)
  if key == "j" then

    gamestate = "game"
    game_init()

  elseif key == "s" then
    love.event.quit()
  end
end
