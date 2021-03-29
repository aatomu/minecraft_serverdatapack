###時間
##起動時間
#tickごとに+1
scoreboard players add tick times 1
#1秒検知
execute if score tick times matches 20.. run scoreboard players add sec times 1
execute if score tick times matches 20.. run scoreboard players remove tick times 20
#1分検知
execute if score sec times matches 60.. run scoreboard players add min times 1
execute if score sec times matches 60.. run scoreboard players remove sec times 60
#1時間検知
execute if score min times matches 60.. run scoreboard players add hour times 1
execute if score min times matches 60.. run scoreboard players remove min times 60
#1日検知
execute if score hour times matches 24.. run scoreboard players add day times 1
execute if score hour times matches 24.. run scoreboard players remove hour times 24

##MC内時間
#時間を代入
execute store result score MC_daytime times run time query daytime
#1分を計算
scoreboard players operation MC_min times = MC_daytime times
scoreboard players operation MC_min times /= *16 times
scoreboard players operation MC_hour times = MC_min times
scoreboard players operation MC_min times %= *60 times
#1時間を計算
scoreboard players operation MC_hour times /= *60 times

##ワールドの時間
execute in minecraft:overworld unless block 0 255 0 repeating_command_block run setblock 0 255 0 minecraft:repeating_command_block{Command:"empty",auto:1b}
execute in minecraft:overworld store result score world_time times run data get block 0 255 0 LastExecution
#1tickを計算
scoreboard players operation world_tick times = world_time times
scoreboard players operation world_tick times /= *20 times
scoreboard players operation world_sec times = world_tick times
scoreboard players operation world_tick times = world_time times
scoreboard players operation world_tick times %= *20 times
#1secを計算
scoreboard players operation world_data times = world_sec times
scoreboard players operation world_sec times /= *60 times
scoreboard players operation world_min times = world_sec times
scoreboard players operation world_sec times = world_data times
scoreboard players operation world_sec times %= *60 times
#1minを計算
scoreboard players operation world_data times = world_min times
scoreboard players operation world_min times /= *60 times
scoreboard players operation world_hour times = world_min times
scoreboard players operation world_min times = world_data times
scoreboard players operation world_min times %= *60 times
#1hourを計算
scoreboard players operation world_data times = world_hour times
scoreboard players operation world_hour times /= *24 times
scoreboard players operation world_day times = world_hour times
scoreboard players operation world_hour times = world_data times
scoreboard players operation world_hour times %= *24 times

##相対リアルタイムチェック
execute in minecraft:the_nether store result score real_time times run worldborder get
scoreboard players add real_time_check times 1
execute in minecraft:the_nether if score real_time times matches ..100 run worldborder set 100 0
execute in minecraft:the_nether if score real_time times matches ..100 run worldborder set 120 1
execute in minecraft:the_nether if score real_time times matches 120.. run worldborder set 100 0
execute in minecraft:the_nether if score real_time times matches 120.. run worldborder set 120 1
execute in minecraft:the_nether if score real_time times matches 120.. in minecraft:the_nether store result score real_time_check times run worldborder get
execute in minecraft:the_nether if score real_time times matches 120.. store result score real_time times run worldborder get
execute if score real_time_chancel times matches 0 unless score real_time times = real_time_check times run me <Warning> The world is overloaded.
execute if score real_time_chancel times matches 0 unless score real_time times = real_time_check times at @a run playsound minecraft:entity.cat.ambient master @a ~ ~ ~ 1 2
execute if score real_time_chancel times matches 0 unless score real_time times = real_time_check times run scoreboard players set real_time_chancel times 20
execute unless score real_time times = real_time_check times in minecraft:the_nether store result score real_time_check times run worldborder get
execute if score real_time_chancel times matches 1.. run scoreboard players remove real_time_chancel times 1

##表示
title @a[tag=time_view] actionbar [{"text":"","bold":true,"color":"gold"},{"text":"MCtime: "},{"score":{"name":"MC_hour","objective":"times"}},{"text":":"},{"score":{"name":"MC_min","objective":"times"}},{"text":" Servertime: "},{"score":{"name":"day","objective":"times"}},{"text":"/"},{"score":{"name":"hour","objective":"times"}},{"text":":"},{"score":{"name":"min","objective":"times"}},{"text":":"},{"score":{"name":"sec","objective":"times"}},{"text":"."},{"score":{"name":"tick","objective":"times"}},{"text":" Worldtime: "},{"score":{"name":"world_day","objective":"times"}},{"text":"/"},{"score":{"name":"world_hour","objective":"times"}},{"text":":"},{"score":{"name":"world_min","objective":"times"}},{"text":":"},{"score":{"name":"world_sec","objective":"times"}},{"text":"."},{"score":{"name":"world_tick","objective":"times"}}]


#プレイヤー人数
execute store result score *now_player times if entity @a
execute if score *now_player times > *old_player times as @a at @s run playsound minecraft:entity.player.levelup master @s ~ ~ ~ 2
execute if score *now_player times < *old_player times as @a at @s run playsound minecraft:entity.cat.ambient master @s ~ ~ ~ 2
execute store result score *old_player times run scoreboard players get *now_player times

#破壊禁止
execute at @a[tag=no_destory] run summon minecraft:armor_stand ~ ~ ~ {Health:0f,NoGravity:1b,DeathTime:19s,Invisible:1b}

#dimension 移動
execute as @a[tag=world] at @s in minecraft:overworld run tp @s ~ ~ ~
execute as @a[tag=world1] at @s in server_datapack:world1 run tp @s ~ ~ ~
execute as @a[tag=world2] at @s in server_datapack:world2 run tp @s ~ ~ ~
execute as @a[tag=world3] at @s in server_datapack:world3 run tp @s ~ ~ ~
execute if entity @a[tag=world] run scoreboard players set real_time_chancel times 50
execute if entity @a[tag=world1] run scoreboard players set real_time_chancel times 50
execute if entity @a[tag=world2] run scoreboard players set real_time_chancel times 50
execute if entity @a[tag=world3] run scoreboard players set real_time_chancel times 50
tag @a[tag=world] remove world
tag @a[tag=world1] remove world1
tag @a[tag=world2] remove world2
tag @a[tag=world3] remove world3

#entityのかず
execute store result score area_effect_cloud entitys if entity @e[type=area_effect_cloud,tag=!no_check]
execute store result score armor_stand entitys if entity @e[type=armor_stand,tag=!no_check]
execute store result score arrow entitys if entity @e[type=arrow,tag=!no_check]
execute store result score bat entitys if entity @e[type=bat,tag=!no_check]
execute store result score bee entitys if entity @e[type=bee,tag=!no_check]
execute store result score blaze entitys if entity @e[type=blaze,tag=!no_check]
execute store result score boat entitys if entity @e[type=boat,tag=!no_check]
execute store result score cat entitys if entity @e[type=cat,tag=!no_check]
execute store result score cave_spider entitys if entity @e[type=cave_spider,tag=!no_check]
execute store result score chest_minecart entitys if entity @e[type=chest_minecart,tag=!no_check]
execute store result score chicken entitys if entity @e[type=chicken,tag=!no_check]
execute store result score cod entitys if entity @e[type=cod,tag=!no_check]
execute store result score command_block_minecart entitys if entity @e[type=command_block_minecart,tag=!no_check]
execute store result score cow entitys if entity @e[type=cow,tag=!no_check]
execute store result score creeper entitys if entity @e[type=creeper,tag=!no_check]
execute store result score dolphin entitys if entity @e[type=dolphin,tag=!no_check]
execute store result score donkey entitys if entity @e[type=donkey,tag=!no_check]
execute store result score dragon_fireball entitys if entity @e[type=dragon_fireball,tag=!no_check]
execute store result score drowned entitys if entity @e[type=drowned,tag=!no_check]
execute store result score egg entitys if entity @e[type=egg,tag=!no_check]
execute store result score elder_guardian entitys if entity @e[type=elder_guardian,tag=!no_check]
execute store result score end_crystal entitys if entity @e[type=end_crystal,tag=!no_check]
execute store result score ender_dragon entitys if entity @e[type=ender_dragon,tag=!no_check]
execute store result score ender_pearl entitys if entity @e[type=ender_pearl,tag=!no_check]
execute store result score enderman entitys if entity @e[type=enderman,tag=!no_check]
execute store result score endermite entitys if entity @e[type=endermite,tag=!no_check]
execute store result score evoker entitys if entity @e[type=evoker,tag=!no_check]
execute store result score evoker_fangs entitys if entity @e[type=evoker_fangs,tag=!no_check]
execute store result score experience_bottle entitys if entity @e[type=experience_bottle,tag=!no_check]
execute store result score experience_orb entitys if entity @e[type=experience_orb,tag=!no_check]
execute store result score eye_of_ender entitys if entity @e[type=eye_of_ender,tag=!no_check]
execute store result score falling_block entitys if entity @e[type=falling_block,tag=!no_check]
execute store result score fireball entitys if entity @e[type=fireball,tag=!no_check]
execute store result score firework_rocket entitys if entity @e[type=firework_rocket,tag=!no_check]
execute store result score fox entitys if entity @e[type=fox,tag=!no_check]
execute store result score furnace_minecart entitys if entity @e[type=furnace_minecart,tag=!no_check]
execute store result score ghast entitys if entity @e[type=ghast,tag=!no_check]
execute store result score giant entitys if entity @e[type=giant,tag=!no_check]
execute store result score guardian entitys if entity @e[type=guardian,tag=!no_check]
execute store result score hoglin entitys if entity @e[type=hoglin,tag=!no_check]
execute store result score hopper_minecart entitys if entity @e[type=hopper_minecart,tag=!no_check]
execute store result score horse entitys if entity @e[type=horse,tag=!no_check]
execute store result score husk entitys if entity @e[type=husk,tag=!no_check]
execute store result score illusioner entitys if entity @e[type=illusioner,tag=!no_check]
execute store result score iron_golem entitys if entity @e[type=iron_golem,tag=!no_check]
execute store result score item entitys if entity @e[type=item,tag=!no_check]
execute store result score item_frame entitys if entity @e[type=item_frame,tag=!no_check]
execute store result score leash_knot entitys if entity @e[type=leash_knot,tag=!no_check]
execute store result score lightning_bolt entitys if entity @e[type=lightning_bolt,tag=!no_check]
execute store result score llama entitys if entity @e[type=llama,tag=!no_check]
execute store result score llama_spit entitys if entity @e[type=llama_spit,tag=!no_check]
execute store result score magma_cube entitys if entity @e[type=magma_cube,tag=!no_check]
execute store result score minecart entitys if entity @e[type=minecart,tag=!no_check]
execute store result score mooshroom entitys if entity @e[type=mooshroom,tag=!no_check]
execute store result score mule entitys if entity @e[type=mule,tag=!no_check]
execute store result score ocelot entitys if entity @e[type=ocelot,tag=!no_check]
execute store result score painting entitys if entity @e[type=painting,tag=!no_check]
execute store result score panda entitys if entity @e[type=panda,tag=!no_check]
execute store result score parrot entitys if entity @e[type=parrot,tag=!no_check]
execute store result score phantom entitys if entity @e[type=phantom,tag=!no_check]
execute store result score pig entitys if entity @e[type=pig,tag=!no_check]
execute store result score piglin entitys if entity @e[type=piglin,tag=!no_check]
#execute store result score piglin_brute entitys if entity @e[type=piglin_brute,tag=!no_check]
execute store result score pillager entitys if entity @e[type=pillager,tag=!no_check]
execute store result score polar_bear entitys if entity @e[type=polar_bear,tag=!no_check]
execute store result score potion entitys if entity @e[type=potion,tag=!no_check]
execute store result score pufferfish entitys if entity @e[type=pufferfish,tag=!no_check]
execute store result score rabbit entitys if entity @e[type=rabbit,tag=!no_check]
execute store result score ravager entitys if entity @e[type=ravager,tag=!no_check]
execute store result score salmon entitys if entity @e[type=salmon,tag=!no_check]
execute store result score sheep entitys if entity @e[type=sheep,tag=!no_check]
execute store result score shulker entitys if entity @e[type=shulker,tag=!no_check]
execute store result score shulker_bullet entitys if entity @e[type=shulker_bullet,tag=!no_check]
execute store result score silverfish entitys if entity @e[type=silverfish,tag=!no_check]
execute store result score skeleton entitys if entity @e[type=skeleton,tag=!no_check]
execute store result score skeleton_horse entitys if entity @e[type=skeleton_horse,tag=!no_check]
execute store result score slime entitys if entity @e[type=slime,tag=!no_check]
execute store result score small_fireball entitys if entity @e[type=small_fireball,tag=!no_check]
execute store result score snow_golem entitys if entity @e[type=snow_golem,tag=!no_check]
execute store result score snowball entitys if entity @e[type=snowball,tag=!no_check]
execute store result score spawner_minecart entitys if entity @e[type=spawner_minecart,tag=!no_check]
execute store result score spectral_arrow entitys if entity @e[type=spectral_arrow,tag=!no_check]
execute store result score spider entitys if entity @e[type=spider,tag=!no_check]
execute store result score squid entitys if entity @e[type=squid,tag=!no_check]
execute store result score stray entitys if entity @e[type=stray,tag=!no_check]
execute store result score strider entitys if entity @e[type=strider,tag=!no_check]
execute store result score tnt entitys if entity @e[type=tnt,tag=!no_check]
execute store result score tnt_minecart entitys if entity @e[type=tnt_minecart,tag=!no_check]
execute store result score trader_llama entitys if entity @e[type=trader_llama,tag=!no_check]
execute store result score trident entitys if entity @e[type=trident,tag=!no_check]
execute store result score tropical_fish entitys if entity @e[type=tropical_fish,tag=!no_check]
execute store result score turtle entitys if entity @e[type=turtle,tag=!no_check]
execute store result score vex entitys if entity @e[type=vex,tag=!no_check]
execute store result score villager entitys if entity @e[type=villager,tag=!no_check]
execute store result score vindicator entitys if entity @e[type=vindicator,tag=!no_check]
execute store result score wandering_trader entitys if entity @e[type=wandering_trader,tag=!no_check]
execute store result score witch entitys if entity @e[type=witch,tag=!no_check]
execute store result score wither entitys if entity @e[type=wither,tag=!no_check]
execute store result score wither_skeleton entitys if entity @e[type=wither_skeleton,tag=!no_check]
execute store result score wither_skull entitys if entity @e[type=wither_skull,tag=!no_check]
execute store result score wolf entitys if entity @e[type=wolf,tag=!no_check]
execute store result score zoglin entitys if entity @e[type=zoglin,tag=!no_check]
execute store result score zombie entitys if entity @e[type=zombie,tag=!no_check]
execute store result score zombie_horse entitys if entity @e[type=zombie_horse,tag=!no_check]
execute store result score zombified_piglin entitys if entity @e[type=zombified_piglin,tag=!no_check]
execute store result score zombie_villager entitys if entity @e[type=zombie_villager,tag=!no_check]
execute store result score player entitys if entity @e[type=player,tag=!no_check]
execute store result score all entitys if entity @e[tag=!no_check]


#荒らしブロックclear
execute as @a[nbt={Inventory:[{id:"minecraft:fire_charge"}]},tag=!no_clear] run me have fire_charge
execute as @a[nbt={Inventory:[{id:"minecraft:fire_charge"}]},tag=!no_clear] run clear @s fire_charge
execute as @a[nbt={Inventory:[{id:"minecraft:flint_and_steel"}]},tag=!no_clear] run me have flint_and_steel
execute as @a[nbt={Inventory:[{id:"minecraft:flint_and_steel"}]},tag=!no_clear] run clear @s flint_and_steel
execute as @a[nbt={Inventory:[{id:"minecraft:tnt"}]},tag=!no_clear] run me have tnt
execute as @a[nbt={Inventory:[{id:"minecraft:tnt"}]},tag=!no_clear] run clear @s tnt
execute as @a[nbt={Inventory:[{id:"minecraft:lava_bucket"}]},tag=!no_clear] run me have lava_bucket
execute as @a[nbt={Inventory:[{id:"minecraft:lava_bucket"}]},tag=!no_clear] run clear @s lava_bucket
execute as @a[nbt={Inventory:[{id:"minecraft:tnt_minecart"}]},tag=!no_clear] run me have tnt_minecart
execute as @a[nbt={Inventory:[{id:"minecraft:tnt_minecart"}]},tag=!no_clear] run clear @s tnt_minecart
execute as @a[nbt={Inventory:[{id:"minecraft:respawn_anchor"}]},tag=!no_clear] run me have respawn_anchor
execute as @a[nbt={Inventory:[{id:"minecraft:respawn_anchor"}]},tag=!no_clear] run clear @s respawn_anchor
