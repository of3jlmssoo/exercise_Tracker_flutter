## Widget Tree 0

```text
MyApp
 MaterialApp
  MyHomePage
   Container
    CustomScrollView
     SliverAppBar 上段の"exercise tracker"の表示
     SliverList
     SliverGrid
        Card
        Card
```

### Widget Tree SliverList

```text
SliverList
 Container
  Row
    SizedBox
    Text       'tap icon to start'
    Row
        SizedBox
            Column
            Text '$_remaingTime'
        SizedBox
        Text        'sec'
        IconButton  cancel icon
    Text    'remain'
    Row
        SizedBox
            Column
                Text '$_counter'
    Row
        IconButton  Icons.alarm
        IconButton  Icons.edit
    SizedBox
```

### Widget Tree SliverGrid

```text
SliverGrid
    gridDelegate : const SliverGridDelegateWithMaxCrossAxisExtent
    delegate : SliverChildBuilderDelegate
        return Card
            InkWell     タイマースタート
                Column
                    imageList[index].$1     "exercise name" // https://dart.dev/language/records?ref=awarefy.dev
                    Container               icon
```

## メモ

displayTimer()で画面表示

```text
StateNotifierProviderはStateNotifierとセットで使われる

final timerProvider = StateNotifierProvider( (ref) => TimerNotifier());

class TimerNotifier extends StateNotifier<対象> {
    timer関連メソッド
}
```
