import 'package:flame/game.dart';

List<dynamic> imageSource = [
  /// block characters page 1
  /// begginner level
  [
    {
      'source': 'characters_skill_game/1_1000x880.png',
      'size': Vector2(10, 8.8),
    },
    {
      'source': 'characters_skill_game/2_1000x880.png',
      'size': Vector2(10, 8.8),
    },
    {
      'source': 'characters/1000x600/soomy-1.png',
      'size': Vector2(12, 8.4),
    },
    {
      'source': 'characters/1000x600/soomy-2.png',
      'size': Vector2(10 * 1.2, 6 * 1.2),
    },
    {
      'source': 'characters/1000x600/soomy-3.png',
      'size': Vector2(12, 8.4),
    },
    {
      'source': 'characters/bots/1000x666/crazy-bot-1000.png',
      'size': Vector2(10 * 1.2, 6.66 * 1.2),
    },
    {
      'source': 'characters/bots/1000x666/crazy-bot-3000.png',
      'size': Vector2(10 * 1.2, 6.66 * 1.2),
    },

////// NEXT
    /// diamond characters
    /// blue backgrounds
    {
      'source': 'characters_skill_game/3_500x1000.png',
      'size': Vector2(5, 10),
    },

    {
      'source': 'characters/object/1000x1000/happy_asymmetric_cube.png',
      'size': Vector2(10, 10),
    },

    {
      'source': 'characters_skill_game/4_500x1000.png',
      'size': Vector2(5, 10),
    },

    /// final levels
    {
      'source':
          'characters/hoomy_with_weapon/1000x666/green_hoomy_with_football.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source':
          'characters/hoomy_with_weapon/1000x666/pink_hoomy_with_flail.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source':
          'characters/hoomy_with_weapon/1000x666/light_green_hoomy_with_knife.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },

    /// devil characters // secret
    {
      'source': 'characters_skill_game/16_1000x1140.png',
      'size': Vector2(10, 8),
    },
    {
      'source': 'characters_skill_game/17_1000x1140.png',
      'size': Vector2(10, 8),
    },
    {
      'source': 'characters_skill_game/18_1000x1140.png',
      'size': Vector2(10, 8),
    },

    {
      'source': 'characters_skill_game/6_1000x1000.png',
      'size': Vector2(10, 10),
    },

    {
      'source': 'characters_skill_game/5_1000x1000.png',
      'size': Vector2(10, 10),
    },
  ],

  [
    /// hoomy level
    /// hoomicy :D
    {
      'source': 'characters/hoomy/1000x666/yellow_hoomy.png',
      'size': Vector2(10 * 1.15, 8 * 1.15),
    },
    {
      'source': 'characters/hoomy/1000x666/psychedelic_hoomy.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source': 'characters/hoomy/1000x1000/blue_happy_hoomy.png',
      'size': Vector2(11, 11),
    },
    {
      'source': 'characters/hoomy/1000x666/pirate_hoomy.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source':
          'characters/hoomy_with_weapon/1000x666/green_hoomy_with_football.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source':
          'characters/hoomy_with_weapon/1000x666/pink_hoomy_with_flail.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source':
          'characters/hoomy_with_weapon/1000x666/light_green_hoomy_with_knife.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
  ],
  [
    /// sea Level
    /// sea level charaktery :D
    {
      'source': 'characters/fish/1500x500_poter.png',
      'size': Vector2(15, 5),
    },
    {
      'source': 'characters/fish/1000x666/fish_hoomy.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source': 'characters/fish/1000x1000/symmetric_rick_fish.png',
      'size': Vector2(10 * 1.3, 10 * 1.3),
    },
    {
      'source': 'characters/fish/1000x666/fish_hoomy_2.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
    {
      'source': 'characters/fish/1000x700_blue_fish.png',
      'size': Vector2(10 * 1.2, 7 * 1.2),
    },
    {
      'source': 'characters/fish/1000x933_red_fish.png',
      'size': Vector2(10 * 1.2, 9.33 * 1.2),
    },
    {
      'source': 'characters/fish/1300x928_octopus.png',
      'size': Vector2(13, 9.28),
    },
  ],
  [
    /// CITY WORLD LEVEL
    /// city level charaktery :D

    /// 6 level characters
    ///
    {
      'source': 'food/300x150/butter.png',
      'size': Vector2(9 * 1.3, 4.5 * 1.3),
    },
    {
      'goal': 5,
      'source': 'food/150x275/pear.png',
      'size': Vector2(1.5 * 4, 2.75 * 4),
    },
    {
      'goal': 2,
      'source': 'food/100x215/milk.png',
      'size': Vector2(3 * 1.5, 6.45 * 1.5),
    },
    {
      'goal': 8,
      'source': 'food/300x275/mufin.png',
      'size': Vector2(3 * 3 * 1.3, 2.75 * 3 * 1.3),
    },
    {
      'goal': 8,
      'source': 'food/300x215/hamburger.png',
      'size': Vector2(3 * 3 * 1.3, 2.5 * 3 * 1.3),
    },
    {
      'source': 'food/300x250/chinese_soup.png',
      'size': Vector2(3 * 3 * 1.3, 2.75 * 3 * 1.3),
    },
  ],
  [
    /// BLUE WORLD LEVEL
    /// BLUE level charaktery :D

    /// free characters
    {
      'source': 'characters_skill_game/7_1000x750.png',
      'size': Vector2(10 * 1.2, 7.5 * 1.2),
    },
    {
      'source': 'characters_skill_game/8_1000x750.png',
      'size': Vector2(10 * 1.2, 7.5 * 1.2),
    },
    {
      'source': 'characters_skill_game/9_1000x800.png',
      'size': Vector2(10 * 1.2, 8 * 1.2),
    },

    /// 6 level characters
    ///
    {
      'source': 'characters_skill_game/3_500x1000.png',
      'size': Vector2(5 * 1.3, 10 * 1.3),
    },
    {
      'source': 'characters_skill_game/4_500x1000.png',
      'size': Vector2(5 * 1.4, 10 * 1.4),
    },
    {
      'source': 'characters_skill_game/5_1000x1000.png',
      'size': Vector2(10 * 1.2, 10 * 1.2),
    },
    {
      'source': 'characters_skill_game/6_1000x1000.png',
      'size': Vector2(10 * 1.2, 10 * 1.2),
    },
    {
      'source': 'characters_skill_game/12_1000x820.png',
      'size': Vector2(10 * 1.2, 8.2 * 1.2),
    },
    {
      'source': 'characters/object/1000x666/friendly_cloud.png',
      'size': Vector2(10 * 1.3, 6.66 * 1.3),
    },
  ],
];

List cityFoods = [
  /// LEVEL 1
  {
    'debug': 'tohle je level 1',
    'sum': 2,
    'characters': [
      {
        'goal': 7,
        'source': 'food/150x275/carrot.png',
        'size': Vector2(1.5 * 4, 2.75 * 4),
      },
      {
        'goal': 5,
        'source': 'food/150x275/pear.png',
        'size': Vector2(1.5 * 4, 2.75 * 4),
      },
      {
        'goal': 2,
        'source': 'food/300x300/tomato.png',
        'size': Vector2(9 * 1.3, 9 * 1.3),
      },
      // {
      //   'goal': 1,
      //   'source': 'food/300x150/butter.png',
      //   'size': Vector2(9 * 1.3, 4.5 * 1.3),
      // },
    ],
  },

  /// LEVEL 2
  {
    'debug': 'tohle je level 2',
    'sum': 3,
    'characters': [
      {
        'goal': 8,
        'source': 'food/300x150/butter.png',
        'size': Vector2(9 * 1.3, 4.5 * 1.3),
      },
      {
        'goal': 5,
        'source': 'food/300x250/cheese.png',
        'size': Vector2(9 * 1.3, 7.5 * 1.3),
      },
      {
        'goal': 3,
        'source': 'food/300x215/tofu.png',
        'size': Vector2(9 * 1.5, 6.45 * 1.5),
      },
      {
        'goal': 1,
        'source': 'food/100x215/milk.png',
        'size': Vector2(3 * 1.5, 6.45 * 1.5),
      },
    ],
  },

  /// LEVEL 3
  {
    'debug': 'tohle je level 3',
    'sum': 3,
    'characters': [
      {
        'goal': 10,
        'source': 'food/300x120/candy.png',
        'size': Vector2(3 * 3 * 1.3, 1.2 * 3 * 1.3),
      },
      {
        'goal': 8,
        'source': 'food/300x275/mufin.png',
        'size': Vector2(3 * 3 * 1.3, 2.75 * 3 * 1.3),
      },
      {
        'goal': 4,
        'source': 'food/200x285/ice_cream.png',
        'size': Vector2(8 * 1.5, 2.85 * 4 * 1.5),
      },
      {
        'goal': 1,
        'source': 'food/300x300/lolipop.png',
        'size': Vector2(9 * 1.5, 9 * 1.5),
      },
    ],
  },

  /// LEVEL 4
  {
    'debug': 'tohle je level 4',
    'sum': 3,
    'characters': [
      {
        'goal': 10,
        'source': 'food/200x250/fries.png',
        'size': Vector2(2 * 3 * 1.3, 2.5 * 3 * 1.3),
      },
      {
        'goal': 8,
        'source': 'food/300x215/fried_egg.png',
        'size': Vector2(3 * 3 * 1.3, 2.5 * 3 * 1.3),
      },
      {
        'goal': 4,
        'source': 'food/300x215/hamburger.png',
        'size': Vector2(3 * 3 * 1.3, 2.5 * 3 * 1.3),
      },
      {
        'goal': 1,
        'source': 'food/300x250/steak.png',
        'size': Vector2(3 * 3 * 1.3, 2.5 * 3 * 1.3),
      },
    ],
  },

  /// LEVEL 5
  {
    'debug': 'tohle je level 5',
    'sum': 4,
    'characters': [
      {
        'goal': 12,
        'source': 'food/300x200_granulka.png',
        'size': Vector2(3 * 3 * 1.3, 2 * 3 * 1.3),
      },
      {
        'goal': 10,
        'source': 'food/300x300/cat_food.png',
        'size': Vector2(3 * 3 * 1.3, 3 * 3 * 1.3),
      },
      {
        'goal': 4,
        'source': 'food/300x250/chinese_soup.png',
        'size': Vector2(3 * 3 * 1.3, 2.5 * 3 * 1.3),
      },
      {
        'goal': 2,
        'source': 'food/200x285/juice.png',
        'size': Vector2(2 * 3 * 1.3, 2.85 * 3 * 1.3),
      },
      {
        'goal': 1,
        'source': 'food/300x250/coffee.png',
        'size': Vector2(3 * 3 * 1.3, 2.5 * 3 * 1.3),
      },
    ],
  },
];
