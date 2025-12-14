


Hello everyone, I'm sorry for being late, I need some time to organize the schedule properly. Today I did several things, created a Git repository that will show the project progress, you can already check it out at the link
https://github.com/GlitchiPitch/jetpack-race

please pay attention to the commits, will this format of commit messages be convenient and informative for you. [ current status ] [ game version ] [ commit author ] Then description of changes. If yes, then we keep this option or would you like to improve it? add or remove something

the repository will store all the materials I have made

also for convenience, I will send a separate document in the format you need (.pdf, .docs, etc.) about important changes

for further work, I need to resolve a number of questions, and you can help me with this. I read the GDD and
I have a number of questions

### Obtaining the Jetpack
- How does the player obtain the jetpack (prompt activation or purchase etc.), and in what form (as a tool or some)?

### Camera
- Is a classic camera needed, or a scripted camera?
- If scripted, what requirements should the camera behavior have (following the player, zoom, rotation)?
- Should the camera support different modes (race, menu, cutscenes)?

### Developer Products
- What types of items are available for purchase during flight?
  - Speed boosts
  - Rebirths
  - (others)


I took into account in the development support for future mechanics (speed scaling based on skills)

currently, the main project structure has been created (implemented leaderboard systems, flight, pets, rewards, rebirths) and mechanics are partially implemented, I continue to work on them

I remember that you wrote about Trello, if you give me access, I will mark the progress there


Also, I only very recently started practicing English again and didn't think it would be needed so soon, but I'm not quite ready for live communication yet, I need time to practice English. 

------

-- ответы
управляемое перемещение происходит с постоянной скоростью
игрок может двигаться только влево-вправо

бафы и дебафы лежат на трасе когда игрок попадает в их поле, то они собираются игроком и попадают к нему
временные ускорения
замедления
нужны расширенные лимиты пэтов которые может экипировать игрок, +3 +7
в будущем нужно будет разводить питомцев, скорее всего ферма
и торговать питомцами

также нужно добавить блестящих питомцев
возможность расширения до радужных питомцев
индикаторы заблокированных питомцев для создания ажиотажа

дев продукты блестящий питомец, (дальше добавить)
и геймпассы

подключение к игре (UI)

также добавить магазин с косметикой, разные ранцы за ранзые цены

проверить что внедрена система ускорения
интегрирована таблица лидеров в реальном времени ( в виде длинного фрейма, на котором отображается расстояние каждого игрока от финиша )

система питомцев должна быть стандартная, но все питомцы летающие ( вокруг модели игрока есть 8 точек, это максимальное количество питомцев которое может носить с собой игрок. игрок открывает себе количество питомцев за покупка за робаксы. изначально игрок может носить одного, накопив софт валюты он может открыть возможноть носить второго питомца, но нужно сделать чтобы это затрачивало от 2 до 4 часов. или можно купить за робуксы, medium pets который даст +3 и big pets +4 ) все 8 питомцев могут экипроваться.

когда игрок экиприует питомца, на точке появялется модель питомца, внутри него нет хуманоида, но есть AnimationController через него когда игрок двигается у питомцев включается две анимации idle и move. когда у питомцев состояние idle они должны смотреть куда смотрит игрок. когда move тоже

питомцы экипируются через UI. нужно будет сделать окно где игрок может выбрать разных питомцев

и важно првоерить монетизацию питомцев



