import 'package:flame/components.dart';

Map<String, dynamic> charactersForInventory = {
  'null' : {
    'source': 'characters_skill_game/1_1000x880.png',
    'size': Vector2(10, 8.8),
  },
  'soomy0': {
    'source': 'characters_skill_game/1_1000x880.png',
    'size': Vector2(10, 8.8),
  },
  'soomy1': {
    'source': 'characters_skill_game/2_1000x880.png',
    'size': Vector2(10, 8.8),
  },
  'soomy2': {
    'source': 'characters/1000x600/soomy-1.png',
    'size': Vector2(12, 8.4),
  },
  'soomy3': {
    'source': 'characters/1000x600/soomy-2.png',
    'size': Vector2(10 * 1.2, 6 * 1.2),
  },
  'soomy4': {
    'source': 'characters/1000x600/soomy-3.png',
    'size': Vector2(12, 8.4),
  },
  'soomy5': {
    'source': 'characters/bots/1000x666/crazy-bot-1000.png',
    'size': Vector2(10 * 1.2, 6.66 * 1.2),
  },
  'soomy6': {
    'source': 'characters/bots/1000x666/crazy-bot-3000.png',
    'size': Vector2(10 * 1.2, 6.66 * 1.2),
  },
  'sea0': {
    'source': 'characters/fish/1500x500_poter.png',
    'size': Vector2(15, 5),
  },
  'sea1': {
    'source': 'characters/fish/1000x550xfish1.png',
    'size': Vector2(10 * 1.3, 5.5 * 1.3),
  },
  'sea2': {
    'source': 'characters/fish/1000x1000/symmetric_rick_fish.png',
    'size': Vector2(10 * 1.3, 10 * 1.3),
  },
  'sea3': {
    'source': 'characters/fish/1000x500xfish2.png',
    'size': Vector2(10 * 1.3, 5 * 1.3),
  },
  'sea4': {
    'source': 'characters/fish/1000x700_blue_fish.png',
    'size': Vector2(10 * 1.2, 7 * 1.2),
  },
  'sea5': {
    'source': 'characters/fish/1000x933_red_fish.png',
    'size': Vector2(10 * 1.2, 9.33 * 1.2),
  },
  'sea6': {
    'source': 'characters/fish/1300x928_octopus.png',
    'size': Vector2(13, 9.28),
  },
  'hoomy0':
  {
    'source': 'characters/hoomy/1000x666/yellow_hoomy.png',
    'size': Vector2(10 * 1.15, 8 * 1.15),
  },
  'hoomy1':
  {
    'source': 'characters/hoomy/1000x666/psychedelic_hoomy.png',
    'size': Vector2(10 * 1.3, 6.66 * 1.3),
  },
  'hoomy2':
  {
    'source': 'characters/hoomy/1000x1000/blue_happy_hoomy.png',
    'size': Vector2(11, 11),
  },
  'hoomy3':
  {
    'source': 'characters/hoomy/1000x666/pirate_hoomy.png',
    'size': Vector2(10 * 1.3, 6.66 * 1.3),
  },
  'hoomy4':
  {
    'source':
    'characters/hoomy_with_weapon/1000x666/green_hoomy_with_football.png',
    'size': Vector2(10 * 1.3, 6.66 * 1.3),
  },
  'hoomy5':
  {
    'source':
    'characters/hoomy_with_weapon/1000x666/pink_hoomy_with_flail.png',
    'size': Vector2(10 * 1.3, 6.66 * 1.3),
  },
  'hoomy6':
  {
    'source':
    'characters/hoomy_with_weapon/1000x666/light_green_hoomy_with_knife.png',
    'size': Vector2(10 * 1.3, 6.66 * 1.3),
  },
  'city0' : {
    'source': 'food/300x150/butter.png',
    'winCharacterReferenceNameId' : 'city0',
    'size': Vector2(9 * 1.3, 4.5 * 1.3),
  },
  'city1' : {
    'goal': 5,
    'source': 'food/150x275/pear.png',
    'winCharacterReferenceNameId' : 'city1',
    'size': Vector2(1.5 * 4, 2.75 * 4),
  },
  'city2' :{
    'goal': 2,
    'source': 'food/100x215/milk.png',
    'winCharacterReferenceNameId' : 'city2',
    'size': Vector2(3 * 1.5, 6.45 * 1.5),
  },
  'city3' :
  {
    'goal': 8,
    'source': 'food/300x275/mufin.png',
    'winCharacterReferenceNameId' : 'city3',
    'size': Vector2(3 * 3 * 1.3, 2.75 * 3 * 1.3),
  },
  'city4' :
  {
    'goal': 8,
    'source': 'food/300x215/hamburger.png',
    'winCharacterReferenceNameId' : 'city4',
    'size': Vector2(3 * 3 * 1.3, 2.5 * 3 * 1.3),
  },
  'city5' :
  {
    'source': 'food/300x250/chinese_soup.png',
    'winCharacterReferenceNameId' : 'city5',
    'size': Vector2(3 * 3 * 1.3, 2.75 * 3 * 1.3),
  },
  'purple1' : {
    'source' : 'characters_skill_game/4_500x1000.png',
    'size' : Vector2(5 * 3, 10 * 3),
  },
  'purple2' : {
    'source' : 'characters_skill_game/7_1000x750.png',
    'size' : Vector2(10 * 3, 7.5 * 3),
  } , 'purple3' : {
    'source' : 'characters_skill_game/8_1000x750.png',
    'size' : Vector2(8 * 3, 7.5 * 3),
  },
  'purple4' : {
    'source' : 'characters_skill_game/5_1000x1000.png',
    'size' : Vector2(10 * 3, 10 * 3),
  },
  'purple5' : {
    'source' : 'characters/food/1000x1500/long_red_wine.png',
    'size' : Vector2(10 * 3, 15 * 3),
  },
  'purple6' : {
    'source' : 'characters/object/1000x1000/happy_asymmetric_cube.png',
    'size' : Vector2(10 * 3, 10 * 3),
  },
  'purple7' : {
    'source' : 'characters/food/1000x1500/long_green_popsickle.png',
    'size' : Vector2(10 * 3, 15 * 3),
  },
  'purple8' : {
    'source' : 'characters/object/1000x666/cat_in_box.png',
    'size' : Vector2(10 * 3, 6.66 * 3),
  },
  'purple9' : {
    'source' : 'characters/object/1000x1000/satisfied_bag.png',
    'size' : Vector2(10 * 3, 10 * 3),
  },
  'purple10' : {
    'source' : 'characters/object/1000x1000/umbrella.png',
    'size' : Vector2(10 * 3, 10 * 3),
  },
  'purple11' : {
    'source' : 'characters_skill_game/6_1000x1000.png',
    'size' : Vector2(10 * 3, 10 * 3),
  },
  'purple12' : {
    'source' : 'characters_skill_game/16_1000x1140.png',
    'size' : Vector2(10 * 3, 11.4 * 3),
  },
  'alien0' : {
    'source' : 'in_app/final_win_character.png',
    'size' : Vector2(10 * 3, 11.4 * 3),
  }
};
