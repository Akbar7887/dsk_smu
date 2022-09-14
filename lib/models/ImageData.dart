import 'Dom.dart';

class ImageData {
    String? datacreate;
    Dom? dom;
    int? id;
    String? imagepath;
    String? name;

    ImageData({ this.datacreate, this.dom, this.id, this.imagepath, this.name});

    factory ImageData.fromJson(Map<String, dynamic> json) {
        return ImageData(
            datacreate: json['datacreate'], 
            dom: json['dom'] != null ? Dom.fromJson(json['dom']) : null, 
            id: json['id'], 
            imagepath: json['imagepath'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['datacreate'] = this.datacreate;
        data['id'] = this.id;
        data['imagepath'] = this.imagepath;
        data['name'] = this.name;
        if (this.dom != null) {
            data['dom'] = this.dom!.toJson();
        }
        return data;
    }
}