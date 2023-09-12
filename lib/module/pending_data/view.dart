import 'package:circular_loader/circular_loader.dart';
import 'package:enerren/util/data.dart';
// import 'package:enerren/component/list_data_component.dart';
import 'package:enerren/util/system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_post_management/error_handling_util.dart';
import 'package:local_post_management/local_post_management.dart';
import 'package:provider/provider.dart';

import 'presenter.dart';

class View extends PresenterState {
  @override
  Widget build(BuildContext context) {
    return CircularLoaderComponent(
      controller: loadingController,
      cover: false,
      successMessageAlign: Alignment.topCenter,
      successMessageBuilder: CircularLoaderComponent.messageSuccessNotifMode,
      loadingDecoration: const BoxDecoration(color: Colors.transparent),
      //add error notif mode
      errorMessageAlign: Alignment.topCenter,
      errorMessageBuilder: CircularLoaderComponent.messageErrorNotifMode,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Pending Data"),
          actions: [
            StreamBuilder<QueueStatus>(
              stream: localPostManagement.queueStatusController.stream,
              initialData: localPostManagement.queueStatus,
              builder: (context, snap) {
                debugPrint(snap.connectionState.toString());
                debugPrint(localPostManagement.queueStatus.toString());
                if (snap.hasData) {
                  return GestureDetector(
                    onTap: () {
                      if (localPostManagement.queueStatus == QueueStatus.idle) {
                        localPostManagement.startQueue();
                      } else {
                        localPostManagement.stopQueue();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        snap.data == QueueStatus.idle
                            ? Icons.play_arrow
                            : Icons.pause,
                        color: snap.data == QueueStatus.idle
                            ? Colors.white
                            : Colors.red,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              // ListDataComponent<QueueModel>(
              //   controller: super.queueController,
              //   autoSearch: false,
              //   enableDrag: false,
              //   enableGetMore: false,
              //   dataSource: (skip, key) {
              //     return localPostManagement.getQueue();
              //   },
              //   itemBuilder: (item, index) {
              //     return Container(
              //         width: double.infinity,
              //         padding: const EdgeInsets.all(10),
              //         margin: const EdgeInsets.all(5),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(5),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.5),
              //               spreadRadius: 1,
              //               blurRadius: 5,
              //               offset: const Offset(
              //                   0, 3), // changes position of shadow
              //             ),
              //           ],
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   item?.status?.toUpperCase() ?? "",
              //                   style: System.data.textStyles!.headLine3,
              //                 ),
              //                 Text(
              //                   item?.createdDate == null
              //                       ? '-'
              //                       : DateFormat("dd MMM yyyy hh:mm:ss",
              //                               System.data.strings!.locale)
              //                           .format(item!.createdDate!),
              //                   style: System.data.textStyles!.headLine3,
              //                 ),
              //               ],
              //             ),
              //             const Divider(
              //               height: 20,
              //               thickness: 1,
              //             ),
              //             Text(
              //               item?.name ?? "",
              //               style: System.data.textStyles!.basicLabel,
              //             ),
              //           ],
              //         ));
              //   },
              // ),
              StreamBuilder<List<QueueModel>>(
                  stream: localPostManagement.queueController.stream,
                  builder: (context, snap) {
                    debugPrint(snap.connectionState.toString());
                    if (snap.connectionState != ConnectionState.active) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snap.hasData) {
                        return ListView(
                          children: List.generate(
                            snap.data?.length ?? 0,
                            (index) {
                              var item = snap.data?[index];
                              return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item?.status?.toUpperCase() ?? "",
                                            style: System
                                                .data.textStyles!.headLine3,
                                          ),
                                          Text(
                                            item?.createdDate == null
                                                ? '-'
                                                : DateFormat(
                                                        "dd MMM yyyy hh:mm:ss",
                                                        System.data.strings!
                                                            .locale)
                                                    .format(item!.createdDate!),
                                            style: System
                                                .data.textStyles!.headLine3,
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        height: 20,
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item?.name ?? "",
                                            style: System
                                                .data.textStyles!.basicLabel,
                                          ),
                                          (item?.status?.toUpperCase() ?? "") ==
                                                  "FAILED"
                                              ? Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        localPostManagement
                                                            .reloadQueue(
                                                                item!.id!);
                                                      },
                                                      child: const Icon(
                                                        Icons.refresh,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        localPostManagement
                                                            .deleteQueue(
                                                                item!.id!);
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                      const Divider(
                                        height: 20,
                                        thickness: 1,
                                      ),
                                      Text(
                                        item?.readData.lastError ?? "",
                                        style:
                                            System.data.textStyles!.basicLabel,
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Consumer<Data>(builder: (c, d, w) {
                            return Text(
                              ErrorHandlingUtil.handleApiError(snap.error),
                              style: System.data.textStyles!.basicLabel,
                            );
                          }),
                        );
                      }
                    }
                  }),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      loadingController.stopLoading(
                        message: "ini pesan success",
                        isError: true,
                      );
                      // addNewQueue();
                    },
                  ),
                ),
                alignment: Alignment.bottomRight,
              )
            ],
          ),
        ),
      ),
    );
  }

  void addNewQueue() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: IntrinsicHeight(
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                          child: TextField(
                            controller: urlController,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              hintText: "Url",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                          child: TextField(
                            controller: queryController,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              hintText: "Query",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                          child: TextField(
                            controller: headerController,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              hintText: "header",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                          child: TextField(
                            controller: bodyController,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              hintText: "body",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              addToQueue();
                            },
                            child: const Text("Save"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
