import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../home/widgets/lists/user_list.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AddFavoriteScreen extends StatefulWidget {
  const AddFavoriteScreen({super.key});

  @override
  State<AddFavoriteScreen> createState() => AddFavoriteScreenState();
}

class AddFavoriteScreenState extends State<AddFavoriteScreen> {
  final TextEditingController searchController = TextEditingController();
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  List<UserModel> selectedUsers = [];
  bool isSearching = false;
  bool isNumericMode = false;
  FocusNode searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    searchList = List.from(list);
  }

  void _onUserSelected(UserModel user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  void _removeSelectedUser(UserModel user) {
    setState(() {
      selectedUsers.remove(user);
    });
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      searchList = list
          .where((user) =>
      user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      if (isSearching) {
        searchController.clear();
        searchFocusNode.unfocus();
        searchList = List.from(list);
      } else {
        searchFocusNode.requestFocus();
      }
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.isDarkMode ? Colors.white.withAlpha((0.1 * 255).toInt()) : Colors.black.withAlpha((0.1 * 255).toInt());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 0,
                blurRadius: 0.5,
                offset: const Offset(0, 0.5),
              ),
            ],
          ),
          child: AppBar(
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
            title: isSearching
                ? TextField(
              key: textFieldKey,
              focusNode: searchFocusNode,
              cursorColor: Colors.blue,
              controller: searchController,
              keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
              decoration: InputDecoration(
                hintText: 'Поиск...',
                hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (value) {
                _onSearchChanged();
              },
            )
            : Text('Добавить в избранное', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
            leading: isSearching
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _toggleSearch();
              },
            )
                : null,
            actions: [
              if (!isSearching)
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _toggleSearch,
                ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedUsers.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: selectedUsers.map((user) {
                      return Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: null,
                                radius: 30,
                                child: CachedNetworkImage(
                                  imageUrl: user.image,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: CircleAvatar(radius: 30, backgroundColor: Colors.grey.shade300),
                                  ),
                                  errorWidget: (context, url, error) => SvgPicture.asset(ChatifyVectors.profile, width: 60, height: 60),
                                  imageBuilder: (context, imageProvider) => CircleAvatar(radius: 30, backgroundImage: imageProvider),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.name.length > 7 ? '${user.name.substring(0, 7)}...' : user.name,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 17,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _removeSelectedUser(user);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 12,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const Divider(),
              ],
            ),
          Expanded(
            child: Stack(
              children: [
                UserList(
                  isSearching: isSearching,
                  searchList: searchList,
                  list: list,
                  isSharing: true,
                  onUserSelected: _onUserSelected,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addFavorite',
        onPressed: () async {},
        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        foregroundColor: Colors.white,
        child: const Icon(Icons.check),
      ),
    );
  }
}
