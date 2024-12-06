import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mow/models/curation_page_model.dart';
import 'package:flutter_mow/models/image_model.dart';
import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/screens/map/curation_page.dart';
import 'package:flutter_mow/services/curation_service.dart';
import 'package:flutter_mow/services/image_service.dart';
import 'package:flutter_mow/services/search_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main_without_border.dart';
import 'package:flutter_mow/widgets/curation_tag.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class EditCurationScreen extends StatefulWidget {
  final int workspaceId;
  final int curationId;

  const EditCurationScreen({
    super.key,
    required this.workspaceId,
    required this.curationId,
  });

  @override
  State<EditCurationScreen> createState() => _EditCurationScreenState();
}

class _EditCurationScreenState extends State<EditCurationScreen> {
  late Future<CurationPageModel> curation; //기존에 작성된 curation 정보 불러오기
  late Future<PlaceDetailModel> workspace; // 가게 정보 불러와서 저장하는 변수
  final TextEditingController titleController =
      TextEditingController(); // 큐레이션 제목 컨트롤러
  final TextEditingController contentController =
      TextEditingController(); // 큐레이션 내용 컨트롤러
  List<String> selectedTagList = []; //선택된 태그들 저장
  //이미지 관련 변수
  final picker = ImagePicker();
  List<String> imageUrlList = []; //기존의 이미지 Url을 저장하는 리스트(최대 10개)
  List<XFile?> galleryImageList = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> selectedImageList = []; // 가져온 사진들을 보여주기 위한 변수
  // 수정된 큐레이션을 업로드할 때 로딩
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //큐레이션 api 호출
    curation = CurationService.getCurationById(widget.curationId, 0, 0, 20);
    //장소 api 호출
    workspace = SearchService.getPlaceById(widget.workspaceId);
    // 큐레이션 로딩 완료 후 값을 다른 변수에 저장
    curation.then((value) {
      setState(() {
        selectedTagList = value.featureTagsList; // 태그 리스트 저장
        titleController.text = value.curationTitle;
        contentController.text = value.text;
        imageUrlList = value.imageList; // 기존의 이미지 url 저장(추후 수정)
      });
    });
  }

  // url로 이동하는 함수
  Future<void> _openWebsite(String link) async {
    final Uri url = Uri.parse(link);

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // 기본 브라우저에서 열기
      );
    } catch (e) {
      print('링크 열기 실패: $e');
    }
  }

  // 사진 추가 버튼을 눌렀을 때 호출되는 함수
  void addImage() async {
    //이미지 선택하기
    galleryImageList = await picker.pickMultiImage();
    //이미지 선택이 끝났을 때
    //pickMultiImage 통해 갤러리에서 가지고 온 사진들은 galleryImageList에 저장되므로 addAll()을 사용해서 selectedImageList와 galleryImageList 를 합쳐줌
    selectedImageList.addAll(galleryImageList);
    //기존의 이미지url과 새로 선택된 이미지 파일의 개수의 합이 10개를 초과했을 경우 앞에 이미지부터 제거함
    if (imageUrlList.length + selectedImageList.length > 10) {
      while (imageUrlList.length + selectedImageList.length > 10) {
        // 기존의 이미지 url이 있다면 앞에부터 하나씩 제거
        if (imageUrlList.isNotEmpty) {
          imageUrlList.removeAt(0);
        } else {
          // 기존의 이미지 url이 남아있지 않다면 새로 선택된 이미지 파일을 촤과한만큼 제거
          selectedImageList.removeRange(0, selectedImageList.length - 10);
        }
      }
    }
    setState(() {});
  }

  // 아미지 파일 이름을 간소화시키는 함수
  String getValidFileName(String filePath) {
    // 파일 이름을 '/' 기준으로 분리
    List<String> parts = filePath.split('/');

    if (parts.isNotEmpty) {
      return parts.last;
    } else {
      return filePath; // 파일 이름이 '/'을 포함하지 않는 경우 원본 반환
    }
  }

  // 수정완료 버튼을 눌렀을 때
  Future<void> onClickButtonHandler() async {
    if (selectedTagList.isNotEmpty &&
        titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty) {
      // 새로 추가한 이미지 파일을 url로 변환하고 imageUrlList에 추가

      // aws s3 버킷에 업로드하고 url 받아오기
      try {
        for (int i = 0; i < selectedImageList.length; i++) {
          // 1. preSignedUrl 받아오기(현재시간, 수정된 파일 이름을 사용해서 filename으로 사용)
          String validFilename =
              getValidFileName(selectedImageList[i]!.path); //파일 이름 수정
          DateTime currentTime = DateTime.now();
          String formattedTime =
              "${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}"
              "${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}${currentTime.second.toString().padLeft(2, '0')}"; //현재 시간 가져오기

          ImageModel imageModel =
              await ImageService.getImageUrl('${formattedTime}_$validFilename');

          // 2. S3 버킷에 이미지 업로드 요청
          int uploadImageResult = await ImageService.uploadImage(
              imageModel.preSignedUrl, selectedImageList[i]!);

          // 3. imageUrlList에 permanentUrl 저장
          if (uploadImageResult == 200) {
            // 성공하면 imageUrlList에 permanentUrl 추가
            imageUrlList.add(imageModel.permanentUrl);
          } else {
            // 실패하면 함수 종료
            return;
          }
        }
      } catch (e) {
        print('Error during upload image: $e');
        throw Error();
      }

      //비동기 처리를 함으로써 editCuration 작업이 다 끝난 뒤에 CurationPage로 이동
      await CurationService.editCuration(
        widget.curationId,
        titleController.text,
        contentController.text,
        selectedTagList,
        widget.workspaceId,
        imageUrlList,
      );
      // 1. 현재 화면(EditCurationScreen)을 먼저 제거
      Navigator.pop(context);

      // 2. 큐레이션 페이지를 제거함으로써 curation place를 미리 reload함.
      Navigator.pop(context, true);

      // 3. 다시 CurationPage화면을 불러옴(CurationPage를 새로 호출함으로써 변경사항을 반영시킴)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CurationPage(
            curationId: widget.curationId,
            workspaceId: widget.workspaceId,
          ),
        ),
      );
    }
  }

  String formatDateTime(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month =
        dateTime.month.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 0 추가
    String day = dateTime.day.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 0 추가
    return '$year.$month.$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const AppbarBack(),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                // 화면의 다른 곳을 터치할 때 포커스 해제
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 18.0,
                  ),
                  //스크롤 되는 부분
                  Expanded(
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                          future: curation,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // 데이터가 로드 중일 때 로딩 표시
                              return const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xFFAD7541),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              // 오류가 발생했을 때
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // 큐레이션 정보 로딩 완료
                              return Column(
                                children: [
                                  //배경 이미지, 태그, 제목, 날짜
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFD9D9D9)),
                                    width: double.infinity,
                                    height: 368,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // 배경 이미지(기존에 작성된 큐레이션의 이미지 url 혹은 새로 추가한 이미지 파일)
                                        imageUrlList.isNotEmpty
                                            // 1. 기존에 작성된 큐레이션의 이미지 url
                                            ? Image.network(
                                                imageUrlList[0],
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const SizedBox
                                                      .shrink(); // 에러 시 아무것도 표시하지 않음
                                                },
                                              )
                                            //기존에 작성된 큐레이션의 이미지 url이 없을 경우
                                            //수정하면서 새로 추가한 이미지 파일을 가져옴
                                            : selectedImageList.isNotEmpty
                                                // 2. 새로 추가한 이미지 파일
                                                ? Image.file(
                                                    File(selectedImageList[0]!
                                                        .path), // File로 변환하여 로컬 이미지 불러오기
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const SizedBox
                                                          .shrink(); // 에러 시 아무것도 표시하지 않음
                                                    },
                                                  )
                                                // 새로 추가한 이미지도 없다면 아무것도 보여주지 않음
                                                : const SizedBox.shrink(),

                                        // 배경 이미지를 제외한 나머지 내용
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              bottom: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //태그 추가
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    curationAddTagWidget(
                                                        '+ 태그명 수정하기'),
                                                    for (int n = 0;
                                                        n <
                                                            selectedTagList
                                                                .length;
                                                        n++) ...[
                                                      const SizedBox(
                                                        width: 6.0,
                                                      ),
                                                      curationTagWidget(
                                                          selectedTagList[n]),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              //큐레이션 제목 입력
                                              Column(
                                                children: [
                                                  TextField(
                                                    decoration: InputDecoration(
                                                      border: InputBorder
                                                          .none, // 테두리 없애기
                                                      hintText:
                                                          '큐레이션 제목을\n입력해주세요', // 두 줄의 placeholder 텍스트
                                                      hintMaxLines:
                                                          2, // placeholder 최대 줄 수
                                                      hintStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .headlineLarge!
                                                          .copyWith(
                                                              color: const Color(
                                                                      0xFF323232)
                                                                  .withOpacity(
                                                                      0.5)),
                                                    ),
                                                    maxLength:
                                                        20, // 최대 입력 가능 문자 수
                                                    maxLines:
                                                        2, // 입력 필드를 세 줄로 제한
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                    controller: titleController,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              //작성된 날짜
                                              Row(
                                                children: [
                                                  Text(
                                                    formatDateTime(snapshot
                                                        .data!.createdAt),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //큐레이션 작성자 정보
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/icons/curation_user_default_img.svg'),
                                            const SizedBox(
                                              width: 6.0,
                                            ),
                                            // 유저 닉네임을 SharedPreferences에서 꺼내와야하기 때문에 FutureBuilder로 보여줌.
                                            Text(
                                              snapshot.data!.userNickname,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: const Color(
                                                          0xFFC3C3C3)),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 40.0,
                                        ),
                                        //이미지(최대 열장)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              // 이미지 추가하는 container
                                              GestureDetector(
                                                onTap: () async {
                                                  addImage();
                                                },
                                                child: Container(
                                                  width: 167,
                                                  height: 223,
                                                  color:
                                                      const Color(0xFFF4F4F4),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/icons/curation_add_image_icon.svg'),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text('사진 추가',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall),
                                                      Text('(10장 이내)',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // 기존의 이미지들 url (추후 수정)
                                              for (int n = 0;
                                                  n < imageUrlList.length;
                                                  n++) ...[
                                                const SizedBox(
                                                  width: 6.0,
                                                ),
                                                Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    //이미지 컨테이너
                                                    Container(
                                                        width: 167,
                                                        height: 223,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey[
                                                              200], // 로딩 중일 때 보이는 배경색
                                                        ),
                                                        child: Image.network(
                                                          imageUrlList[n],
                                                          fit: BoxFit.cover,
                                                        )),
                                                    //이미지 삭제 버튼(이미지 선택 취소)
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          imageUrlList.remove(
                                                              imageUrlList[n]);
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: SvgPicture.asset(
                                                            'assets/icons/cancel_select_icon.svg'),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                              // 새로 추가된 이미지들 파일
                                              for (int n = 0;
                                                  n < selectedImageList.length;
                                                  n++) ...[
                                                const SizedBox(
                                                  width: 6.0,
                                                ),
                                                Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Container(
                                                      width: 167,
                                                      height: 223,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: FileImage(File(
                                                              selectedImageList[
                                                                      n]!
                                                                  .path)), // 이미지 파일 불러오기
                                                          fit: BoxFit
                                                              .cover, // 이미지를 컨테이너에 꽉 채우기
                                                        ),
                                                      ),
                                                    ),
                                                    //이미지 삭제 버튼(이미지 선택 취소)
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedImageList.remove(
                                                              selectedImageList[
                                                                  n]);
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: SvgPicture.asset(
                                                            'assets/icons/cancel_select_icon.svg'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 37.0,
                                        ),
                                        //큐레이션 글
                                        Column(
                                          children: [
                                            TextField(
                                              decoration: InputDecoration(
                                                border:
                                                    InputBorder.none, // 테두리 없애기
                                                hintText:
                                                    '큐레이션 내용을 작성해주세요 (200자 이내)', // placeholder 텍스트
                                                hintMaxLines:
                                                    1, // placeholder 최대 줄 수
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium!
                                                    .copyWith(
                                                        color: const Color(
                                                            0xFF868686)),
                                              ),
                                              maxLength: 200, // 최대 입력 가능 문자 수
                                              maxLines: 10, // 입력 필드를 10 줄로 제한
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                              controller: contentController,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 38.0,
                                        ),
                                        //가게 정보
                                        Container(
                                          height: 2.0,
                                          width: 18.0,
                                          color: const Color(0xFF6B4D38),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        //FutureBuilder로 불러오기
                                        FutureBuilder(
                                            future: workspace,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                // 데이터가 로드 중일 때 로딩 표시
                                                return const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color: Color(0xFFAD7541),
                                                    ),
                                                  ],
                                                );
                                              } else if (snapshot.hasError) {
                                                // 오류가 발생했을 때
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                // 장소를 성공적으로 불러왔을 때
                                                return Column(
                                                  children: [
                                                    // 상호명
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 75.0,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '상호명',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineMedium,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data!
                                                              .workspaceName,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 12.0,
                                                    ),
                                                    // 주소
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 75.0,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '주소',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineMedium,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data!.location,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 12.0,
                                                    ),
                                                    //영업시간
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 75.0,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '영업시간',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineMedium,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        openHourWidget(snapshot
                                                            .data!
                                                            .workspaceOperationTime),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 12.0,
                                                    ),
                                                    //가게 URL
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 75.0,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'URL',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineMedium,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            _openWebsite(
                                                                snapshot.data!
                                                                    .spaceUrl);
                                                          },
                                                          child: Text(
                                                            '홈페이지로 이동하기',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                ),
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   snapshot
                                                        //       .data!.spaceUrl,
                                                        //   overflow: TextOverflow
                                                        //       .ellipsis,
                                                        //   maxLines: 2,
                                                        //   style:
                                                        //       Theme.of(context)
                                                        //           .textTheme
                                                        //           .titleSmall,
                                                        // ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 92.0,
                                  ),
                                  //수정 완료 버튼
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await onClickButtonHandler();
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 31.0),
                                      child: ButtonMainWithoutBorder(
                                          text: '수정 완료',
                                          bgcolor: const Color(0xFF6B4D38),
                                          textColor: Colors.white,
                                          opacity:
                                              (selectedTagList.isNotEmpty &&
                                                      titleController
                                                          .text.isNotEmpty &&
                                                      contentController
                                                          .text.isNotEmpty)
                                                  ? 1.0
                                                  : 0.5),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 56.0,
                                  ),
                                ],
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),

            // 수정된 큐레이션을 업로드할 때 로딩 표시
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ));
  }

  //태그명 선택하기 버튼
  Widget curationAddTagWidget(String tagName) {
    return SelectButton(
      height: 24,
      padding: 12,
      bgColor: Colors.white,
      radius: 1000,
      text: tagName,
      textColor: const Color(0xFF9D9D9D),
      textSize: 12.0,
      //선택된 태그들을 불러옴
      onPress: () async {
        var result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return CurationTag(initialSelectedTags: selectedTagList);
          },
        );
        // result가 null(버튼을 누르지 않고 윗부분을 눌러서 showModalBottomSheet을 종료한 경우)
        // 이라면 selectedTagList에 저장
        if (result != null) {
          setState(() {
            selectedTagList = result;
          });
        }
      },
    );
  }

  Widget curationTagWidget(String tagName) {
    return SelectButton(
        height: 24,
        padding: 12,
        bgColor: Colors.white,
        radius: 1000,
        text: tagName,
        textColor: const Color(0xFF9D9D9D),
        textSize: 12.0,
        onPress: () {});
  }

  Widget openHourWidget(Map<String, String> openHour) {
    List<String> daysOfWeek = [
      '월요일',
      '화요일',
      '수요일',
      '목요일',
      '금요일',
      '토요일',
      '일요일',
    ];
    List<String> daysOfWeekFirstWord = [
      '월',
      '화',
      '수',
      '목',
      '금',
      '토',
      '일',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int n = 0; n < daysOfWeek.length; n++) ...[
          Row(
            children: [
              Text(
                daysOfWeekFirstWord[n],
                style: Theme.of(context).textTheme.titleSmall,
              ),
              openHour[daysOfWeek[n]] == null
                  ? Text(
                      '  (알 수 없음)',
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  : Text(
                      '  ${openHour[daysOfWeek[n]]}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
        ],
      ],
    );
  }
}
