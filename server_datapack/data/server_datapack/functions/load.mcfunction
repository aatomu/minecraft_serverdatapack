say server seter loaded
say You can't break a player with a "no_destory"
#スコアボード生成
scoreboard objectives add times dummy
scoreboard objectives add entitys dummy

#スコア設定
scoreboard players set *16 times 16
scoreboard players set *20 times 20
scoreboard players set *24 times 24
scoreboard players set *60 times 60

#ラグチェック
execute in minecraft:the_nether run forceload add ~ ~
scoreboard players set real_time_chancel times 50
