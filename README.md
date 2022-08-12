# auto_sort_wrap_widget
  Auto_sort_wrap_widget automatically wraps it concisely like Tetris. 
  Effective for exposing more data on a small screen.

![sample_image](https://user-images.githubusercontent.com/99699752/184090077-8e4c1ea2-d951-4721-a1a3-692b9b8999c4.png)

## Usage
  
- Results when using Flutter's default widgets
 
```dart
final data = ['show me the money', 'asbcdef', '1234567890', 'hi', 'love'];

Wrap(
  runSpacing: 5,
  spacing: 5,
  children: List.generate(data.length, (index) => _getItem(data[index])),
)
```

![스크린샷 2022-08-12 14 08 11](https://user-images.githubusercontent.com/99699752/184288961-5575222b-5dfb-4aeb-a68a-43a6d3615012.png)



- Results when using AutoSortWrapWidget

```dart
final data = ['show me the money', 'asbcdef', '1234567890', 'hi', 'love'];

AutoSortWrapWidget<String>(
  data: data,
  runSpacing: 5,
  spacing: 5,
  itemBuilder: (context, index, data) => _getItem(data)
);
```

![스크린샷 2022-08-11 17 20 24](https://user-images.githubusercontent.com/99699752/184092588-3f05ff94-0675-4335-a037-d93a716fa4bd.png)



- The data is of type T, and the newline array changes if the items are of different sizes even if the data is the same.

```dart
final data = ['show me the money', 'asbcdef', '1234567890', 'hi', 'love'];   // same data as before

AutoSortWrapWidget<Widget>(
  data: List.generate(data.length, (index) => _getItem(data[index])),
  runSpacing: 5,
  spacing: 5,
  itemBuilder: (context, index, data) => Container(
    child: data,
    padding:  const EdgeInsets.all(5.0),
    color:Colors.blueAccent,
   ),
);
```

![스크린샷 2022-08-12 14 31 05](https://user-images.githubusercontent.com/99699752/184291531-83561a3e-b359-4111-8cc5-fef64168d931.png)




## MIT License
```
Copyright (c) 2018 Simon Leier

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

