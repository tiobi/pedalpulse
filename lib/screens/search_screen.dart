import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/pedal_model.dart';
import '../providers/pedal_provider.dart';
import '../services/algolia/algolia.dart';
import '../screens/request_pedal_screen.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/custom_text_button_widget.dart';
import '../widgets/custom_textfield_widget.dart';
import '../widgets/loading_pedal_card_widget.dart';
import '../widgets/pedal_card_widget.dart';

class SearchScreen extends StatefulWidget {
  final bool isSelectable;
  final bool isModelSheet;

  const SearchScreen({
    Key? key,
    this.isSelectable = false,
    this.isModelSheet = false,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final List<AlgoliaObjectSnapshot> _results = [];
  Algolia algolia = const Algolia.init(
    applicationId: algoliaAppId,
    apiKey: algoliaApiKey,
  );

  void _performSearch(String value) async {
    // dismiss keyboard
    FocusScope.of(context).unfocus();

    if (_controller.text.isEmpty) {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(AppStringManager.enterKeyword),
      ));
      return;
    }

    if (_controller.text.length < 3) {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStringManager.minimumKeywordLength),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    AlgoliaQuery query = algolia.instance.index('pedals').query(value);
    AlgoliaQuerySnapshot snap = await query.getObjects();

    setState(() {
      _results.clear();
      _results.addAll(snap.hits);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PedalModel> pedalList = Provider.of<PedalProvider>(context).pedalList;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isModelSheet
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 8),
                            width: 100,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomTextButtonWidget(
                              placeholder: AppStringManager.done,
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
              CustomTextfieldWidget(
                placeholder: AppStringManager.searchPedals,
                controller: _controller,
                suffixIconButton: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(_controller.text),
                ),
                onSubmitted: _performSearch,
              ),

              // request
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(AppStringManager.cantFindPedal),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const RequestPedalScreen();
                          },
                        );
                      },
                      child: const Text(
                        AppStringManager.requestPedal,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              _isLoading
                  ? Expanded(
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 2 / 3),
                        children: const [
                          LoadingPedalCardWidget(),
                          LoadingPedalCardWidget()
                        ],
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 2 / 3),
                        itemCount: _results.length,
                        itemBuilder: (BuildContext context, int index) {
                          PedalModel pedal =
                              PedalModel.fromMap(_results[index].data);

                          return PedalCardWidget(
                            isSelected: pedalList
                                .any((element) => element.uid == pedal.uid),
                            isSelectable: widget.isSelectable,
                            pedal: pedal,
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
