function EveryItemScr() {
    return [
        {
            name: "Placeholder 1",
            obj: ItemPlaceholder1O,
            sprite: ItemPlaceholder1S,
            cost: 20,
            type: "Scrap",
            description: "Just a thingy"
        },
        {
            name: "YoYo",
            obj: YoYoO,
            sprite: YoYoIconS,
            cost: 50,
            type: "Item",
            description: "YoYo|Follows you and|deals damage"
        },
		{
            name: "Balloon",
            obj: BalloonO,
            sprite: BalloonIconS,
            cost: 70,
            type: "Item",
            description: "Balloon|absorbs 3 hits|then explodes"
        },
		{
            name: "Birdie",
            obj: BirdieO,
            sprite: BirdieIconS,
            cost: 100,
            type: "Item",
            description: "Birdie|your new friend!|that flies around|and deals damage"
        },
		{
            name: "Crow",
            obj: CrowO,
            sprite: CrowIconS,
            cost: 250,
            type: "Item",
            description: "Crow|agressive bird!|but very smart"
        },		
		{
            name: "Cigarette",
            obj: SigarettO,
            sprite: SigarettIconS,
            cost: 40,
            type: "Item",
            description: "Cigarette|more combo points|but -1 hp every 5 levels"
        },
		{
            name: "Beer",
            obj: BeerO,
            sprite: BeerIconS,
            cost: 30,
            type: "Item",
            description: "Beer|double damage for 3 Levels|but your movement is inverted"
        },
		{
            name: "Angel Wings",
            obj: WingsO,
            sprite: WingsIconS,
            cost: 170,
            type: "Item",
            description: "Angel Wings|You can fly|by holding jump"
        },
		{
            name: "Aim",
            obj: CritPowerUpO,
            sprite: PowerUpIconCritS,
            cost: 0,
            type: "PowerUp",
            description: "Gives a chance of|critical damage"
        },
		{
            name: "Pills",
            obj: PillsPowerUpO,
            sprite: PowerUpIconSteroidsS,
            cost: 0,
            type: "PowerUp",
            description: "Powerful kicks"
        },
		{
            name: "Piggy Bank",
            obj: KopilkaPowerUpO,
            sprite: PowerUpIconForceS,
            cost: 0,
            type: "PowerUp",
            description: "get more flowers"
        },
		{
		    name: "Heart",
		    obj: HeartItemO,
		    sprite: HealthS,
		    cost: 30,
		    type: "Heart",
		    description: "Restores 1 heart|Yummm"
		}
    ];
}