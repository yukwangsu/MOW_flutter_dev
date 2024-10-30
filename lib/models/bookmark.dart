class BookmarkListModel {
  final List<BookmarkModel> bookmarkList;

  BookmarkListModel.fromJson(json)
      : bookmarkList = List<BookmarkModel>.from(
            json.map((bookmarkJson) => BookmarkModel.fromJson(bookmarkJson)));
}

class BookmarkModel {
  final int bookmarkListId, color, bookmarkCnt;
  final String bookmarkListTitle;

  BookmarkModel.fromJson(Map<dynamic, dynamic> json)
      : bookmarkListId = json['bookmarkListId'] ?? 0,
        color = json['color'] ?? 0,
        bookmarkCnt = json['bookmarkCnt'] ?? 0,
        bookmarkListTitle = json['bookmarkListTitle'] ?? '';
}
