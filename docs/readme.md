タイマー設定 稼働時間
タイマー設定 余裕

タイマー表示
タイマー起動
タイマー一時停止
タイマーリセット
タイマー経過で音

エクササイズ候補表示
エクササイズセット。Drag and Drop

エクササイズ表示

その日の最初のエクササイズ開始時刻 保持(自動)
全エクササイズ終了ボタン
全エクササイズ終了時刻 保持

記録
その日の全エクササイズ開始時間
その日の全エクササイズ終了時間
各エクササイズ開始時間
各エクササイズ終了時間

記録表示


https://stackoverflow.com/questions/61307264/autoclose-dialog-in-flutter
You can use a Timer to achieve this. You can cancel the timer whenever you want.

Declare a timer property in your class:

Timer _timer;
And change your showDialog code like:

showDialog(
context: context,
builder: (BuildContext builderContext) {
_timer = Timer(Duration(seconds: 5), () {
Navigator.of(context).pop();
});

    return AlertDialog(
      backgroundColor: Colors.red,
      title: Text('Title'),
      content: SingleChildScrollView(
        child: Text('Content'),
      ),
);
}
).then((val){
if (_timer.isActive) {
_timer.cancel();
}
});