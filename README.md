# Double-Click Poison Guard

Project Zomboid Build 42 mod. Double-clicking an item in the player inventory
will not eat or drink it when it is harmful **and you can tell it is harmful**:

- Food: known poison, tainted (when the "tainted water text" sandbox option is
  on), rotten, dangerous raw and not cooked
- Fluids: any poisonous fluid in the mix that the game names (bleach, petrol,
  cleaning liquid, perfume, dye, acid...), or tainted water the game tells you
  about

Vanilla only checks the *primary* fluid of a container, so a water bottle with
some bleach mixed in still gets drunk on double-click, even with the poison
icon showing. This mod catches that.

It never blocks on hidden information: unknown poisonous berries or mushrooms
and tainted water without the sandbox text option behave as in vanilla, so a
blocked double-click never tells you something your character does not know.

The right-click menu is unchanged, so you can still consume the item on purpose.
A red halo text tells you when a double-click was blocked.

Wraps `ISInventoryPane:doContextualDblClick` (client only, no vanilla files
replaced). Safe to add to or remove from existing saves.

## 한국어

인벤토리에서 더블클릭할 때 플레이어가 알 수 있는 위험한 것만 먹거나 마시지 않습니다:
독인 줄 아는 음식, 썩은 음식, 날로 먹으면 위험한 음식, 락스·휘발유·세제 등이 섞인 액체,
게임이 알려주는 오염수. 모르는 독 열매·독버섯은 바닐라와 같아서 정보가 새지 않습니다.
우클릭 메뉴로는 그대로 먹을 수 있습니다.

## License

All rights reserved. No license is granted for redistribution or modified versions.
