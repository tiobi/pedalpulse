import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/custom_textfield_widget.dart';
import '../../../../injection_container.dart';
import '../../../../core/common/managers/string_manager.dart';
import '../../../pedals/domain/entities/pedal_entity.dart';
import '../../../pedals/presentation/widgets/pedal_card_widget.dart';
import '../widgets/loading_pedal_card_widget.dart';
import '../providers/search_provider.dart';
import 'request_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => unFocus(context),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSearchBar(),
              _buildRequest(context),
              _buildResults(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final searchProvider = getIt<SearchProvider>();

    return CustomTextfieldWidget(
      placeholder: AppStringManager.searchPedals,
      controller: searchProvider.searchController,
      suffixIconButton: IconButton(
        icon: const Icon(Icons.search),
        onPressed: searchProvider.search,
      ),
    );
  }

  Widget _buildRequest(BuildContext context) {
    return Padding(
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
                  return const RequestPage();
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
    );
  }

  Widget _buildResults(BuildContext context) {
    final SearchProvider searchProvider = Provider.of<SearchProvider>(context);

    return searchProvider.isLoading
        ? Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2 / 3),
              children: const [
                LoadingPedalCardWidget(),
                LoadingPedalCardWidget(),
              ],
            ),
          )
        : Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2 / 3),
              itemCount: searchProvider.pedals.length,
              itemBuilder: (BuildContext context, int index) {
                PedalEntity pedal = searchProvider.pedals[index];

                return PedalCardWidget(
                  isSelected: false,
                  isSelectable: false,
                  pedal: pedal,
                );
              },
            ),
          );
  }

  void unFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
