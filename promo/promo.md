# Climate Change Simulator 2018 Chinese Hoax Edition

Climate change is progressing and destroying planet earth. One day, nature had enough and decided to get rid of this pest called humanity. More and more nature disasters take place and decimate the human population. As many cities are not habitable anymore the people are running out of living space.

You probably thought you will be helping the humans, but you are wrong! You play as nature and your goal is to get rid of every last human being. To do this you have a large tool set of nature disasters at your disposal. Will you send a meteor, a tsunami or even a bear?

## How to play
In each turn you draw a card from the pile. You then have to perform the action displayed on the card. Most of the cards are disaster cards. With these you can choose a city, or for some also a road, where the disaster will take place. There is also a city and a road card. The first will establish a new city and grant humanity some more space to hide from you. Although you can not prevent the creation of the city you can choose where it is built. After drawing the road card you have to build a new road between two cities. To do this, click on the first city and then on the second city. After the action was performed you may draw a new card.

If you don't want to play a card right away you may save at most one. To do this you can click on the card to the left. You can not do this if there is already a card there. To use it later you click the card *before* you draw a card from the pile.

Each city has an associated attractiveness which is influenced by many factors including population, number of connected roads, age and occurred disasters. People will move from cities with low attractiveness to directly connected cities with high attractiveness. The rate at which they move depends on the difference in attractiveness. The attractiveness is displayed with the hearts above the city. The number below the hearts is the population of the city.

A nature disaster will lower a cities attractiveness and thereby might drive people to neighboring cities. It will also kill part of the population. Some disasters kill a certain percentage of the population while others kill a fixed number, or a combination of both. A few disasters can be applied to roads and will destroy the road. The following table shows the effects of the different disasters.

| Disaster     | Relative | Absolute | Attractiveness | Road? |
| ------------ | -------- | -------- | -------------- | ----- |
| Heat Wave    | 5%       | 20 - 30  | 0.1            | No    |
| Thunderstorm | 5%       | -        | 0.2            | No    |
| Earthquake   | 10%      | -        | 0.8            | Yes   |
| Forest Fire  | 40%      | -        | 0.8            | No    |
| Bear Attack  | 50%      | 50 - 200 | 1.2            | No    |
| Plague       | 70%      | -        | 1.7            | No    |
| Meteor       | -        | 50 - 100 | 2.0            | Yes   |
| Tsunami      | -        | 20 - 30  | 2.0            | Yes   |

If the same disaster happens several times in the same city it will boost the effects of the disaster. For this only the last three disasters are taken into account. They are displayed under each city.

You win as soon as the global population reaches zero.

## Controls
You can play the game without a keyboard. For some actions there are keyboard shortcuts:

 - Move map: W/A/S/D or Arrow Keys
 - Next card: Space or Enter
 - Save card: Q

If you wish to turn off the music you can click the button in the top right corner.

## Credits
Design, Code, Audio by Matteo Signer and Benjamin Schmid. Art by Patricia Schmid. Created in [Godot](https://godotengine.org/).
