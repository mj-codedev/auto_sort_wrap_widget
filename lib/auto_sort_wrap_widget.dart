import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef WrapItemBuilder<T> = Widget Function(BuildContext context, int index, T);

class AutoSortWrapWidget<T> extends StatefulWidget {
  const AutoSortWrapWidget({
    Key? key,
    required this.data,
    required this.itemBuilder,
    this.width,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
  }) : super(key: key);

  final List<T> data;
  final WrapItemBuilder<T> itemBuilder;
  final double? width;
  final double spacing;
  final double runSpacing;

  @override
  AutoSortWrapState<T> createState() => AutoSortWrapState<T>();
}

class AutoSortWrapState<T> extends State<AutoSortWrapWidget<T>>  {

  static const Duration ANIMATED_DURATION = const Duration(milliseconds: 400);

  final GlobalKey wrapKey = GlobalKey();

  double? _width;
  double _opacity = 0.0;

  late AutoSortWrapViewModel<T> _viewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)=> _afterLayout());
    _viewModel = AutoSortWrapViewModel<T>(widget.data);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width ??= _getWith(context);

    return ChangeNotifierProvider<AutoSortWrapViewModel>(
        create: (_) =>_viewModel,
        child: _getBody(context)
    );
  }

  _getBody(BuildContext context) {
    return Consumer<AutoSortWrapViewModel>(
        builder: (context, viewModel, child) =>
            Flex(
              direction: Axis.horizontal,
              key: wrapKey,
              children: [
                Flexible(
                    flex: 1,
                    child: AnimatedOpacity(
                        duration: ANIMATED_DURATION,
                        opacity: _opacity,
                        child: _show
                            ? _getContentByLineList(context)
                            : _getTmpContent(context)
                    )
                ),
              ],
            )
    );
  }

  _getTmpContent(BuildContext context){
    return Wrap(
      alignment:  WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: _getTmpItems(context),
    );
  }

  _getTmpItems(BuildContext context) {
    final List<Widget> items = List.generate(_viewModel.flatList.length, (index) {

      return Container(
          key: _viewModel.flatList[index].key,
          child: widget.itemBuilder(context, index, _viewModel.flatList[index].data)
      );
    });

    return items;
  }

  _getContentByLineList(BuildContext context){
    return Column(
      children: _getItems(context),
    );
  }

  _getItems(BuildContext context) {
    final List<Widget> items = List.generate(_viewModel.lineList.length, (index) {

      return Container(
        margin: EdgeInsets.only(
            top: index != 0 ? widget.runSpacing : 0
        ),
        child: Row(
          children: _getItem(context, _viewModel.lineList[index]),
        ),
      );
    });

    return items;
  }

  _getItem(BuildContext context, WrapLineItemModel line) {
    final List<Widget> items = List.generate(line.Items.length, (index) {

      return Container(
          constraints: BoxConstraints(
              maxWidth: _width!
          ),
          key: line.Items[index].key,
          margin: EdgeInsets.only(
              left: index != 0 ? widget.spacing : 0
          ),
          child: widget.itemBuilder(context, index, line.Items[index].data)
      );
    });
    return items;
  }

  _afterLayout() {
    _opacity = 1.0;

    _viewModel.setRenderSize();

    _viewModel.sort(
      wrapSize: _width = _getWrapSize(),
      runSpacing: widget.spacing,
    );
  }

  _getWith(BuildContext context){
    final size = MediaQuery.of(context).size;

    return widget.width ?? size.width;
  }

  _getWrapSize(){
    return (wrapKey.currentContext?.findRenderObject() as RenderBox)?.size?.width;
  }

  bool get _show => _opacity > 0;
}


class AutoSortWrapViewModel<T> extends ChangeNotifier{
  AutoSortWrapViewModel(List<T> items){
    _flatList = items.map((i) => WrapItemModel<T>(i)).toList();
  }

  late List<WrapItemModel<T>> _flatList;
  List<WrapLineItemModel<T>> _lineList = [];

  setRenderSize(){
    List.generate(_flatList.length, (index) {
      _flatList[index].setRenderSize();
    });
  }

  sort({
    required double wrapSize,
    required double runSpacing
  }) {
    _flatList.sort((a, b) => a.width.compareTo(b.width));

    _lineList = [];

    WrapLineItemModel<T> lineModel = WrapLineItemModel<T>(wrapSize, runSpacing);

    while(_flatList.isNotEmpty){
      final WrapItemModel<T> item = _getCompactItem(_flatList, lineModel);

      if(lineModel.allowAdd(item.width)){

        lineModel.addItem(item);
        _flatList.remove(item);

        if(_flatList.isEmpty){
          _lineList.add(lineModel);
        }
      }else {
        if (lineModel.checkLineOver(item.width) && lineModel.isEmpty) {
          lineModel.addItem(item);
          _flatList.remove(item);
        }

        _lineList.add(lineModel);
        lineModel = WrapLineItemModel<T>(wrapSize, runSpacing);
      }
    }

    _lineSortByWidth();

    _flatList = [];

    int i;
    for (i = 0; i < _lineList.length; i++) {
      _flatList.addAll(_lineList[i].Items);
    }

    notifyListeners();
  }

  _lineSortByWidth(){
    int i, j;
    WrapLineItemModel<T> tmp;

    for(i = 0; i < _lineList.length; i ++){
      for(j = i; j < _lineList.length; j++){
        if(_lineList[i].lineWidth < _lineList[j].lineWidth){
          tmp = _lineList[i];
          _lineList[i] = _lineList[j];
          _lineList[j] = tmp;
        }
      }
    }
  }

  _getCompactItem(List<WrapItemModel> tags, WrapLineItemModel lineModel) {
    int i, tmp = 0;
    double tmpWidth = 0.0;

    for(i = 0; i < tags.length; i++){
      if(lineModel.allowAdd(tags[i].width) && (tags[i].width > tmpWidth)){
        tmp = i;
        tmpWidth = tags[i].width;
      }
    }

    return tags[tmp];
  }


  List<WrapItemModel<T>> get flatList => _flatList;
  List<WrapLineItemModel<T>> get lineList => _lineList;
}


class WrapLineItemModel<T> {
  WrapLineItemModel(this.wrapSize, this.spacing) {
    _items = [];
    _lineWidth = 0.0;
  }

  final double wrapSize;
  final double spacing;

  late List<WrapItemModel<T>> _items;
  late double _lineWidth;

  addItem(WrapItemModel<T> item) {
    _items.add(item);
    _lineWidth += (_lineWidth == 0.0 ? 0.0 : spacing);
    _lineWidth += item.width;
  }

  allowAdd(double width){
    return  lineWidth + spacing + width <= wrapSize;
  }

  checkLineOver(double width){
    return lineWidth + spacing + width > wrapSize;
  }

  List<WrapItemModel<T>> get Items => _items;

  double get lineWidth => _lineWidth;

  bool get isEmpty => _items.isEmpty;

  @override
  String toString(){
    return _items.toString();
  }
}


class WrapItemModel<T>{
  WrapItemModel(this.data);

  final GlobalKey key = GlobalKey();

  final T data;

  double? _width;

  setRenderSize(){
    _width = (key.currentContext?.findRenderObject() as RenderBox)?.size?.width;
  }

  double get width => _width ?? 0.0;
}