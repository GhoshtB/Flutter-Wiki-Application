
class SearchResults {
    Continue continues;
    bool batchcomplete;
    Query query;

    SearchResults({this.continues, this.batchcomplete, this.query});

    factory SearchResults.fromJson(Map<String, dynamic> json) {
        return SearchResults(
          continues: json['continues'] != null ? Continue.fromJson(json['continues']) : null,
            batchcomplete: json['batchcomplete'],
            query: json['query'] != null ? Query.fromMap(json['query']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['batchcomplete'] = this.batchcomplete;
        if (this.continues != null) {
            data['continues'] = this.continues.toJson();
        }
        if (this.query != null) {
            data['query'] = this.query.toMap();
        }
        return data;
    }
}

class Query {
    List<Pages> pages;
    List<Redirect> redirects;

    Query({this.pages, this.redirects});

    factory Query.fromMap(Map<String, dynamic> json) {
        return Query(
            pages: json['pages'] != null ? (json['pages'] as List).map((i) => Pages.fromMap(i)).toList() : null,
            redirects: json['redirects'] != null ? (json['redirects'] as List).map((i) => Redirect.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toMap() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.pages != null) {
            data['pages'] = this.pages.map((v) => v.toMap()).toList();
        }
        if (this.redirects != null) {
            data['redirects'] = this.redirects.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Redirect {
    String from;
    int index;
    String to;

    Redirect({this.from, this.index, this.to});

    factory Redirect.fromJson(Map<String, dynamic> json) {
        return Redirect(
            from: json['from'],
            index: json['index'],
            to: json['to'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['from'] = this.from;
        data['index'] = this.index;
        data['to'] = this.to;
        return data;
    }
}

class Pages {
    int index;
    int ns;
    int pageid;
    Terms terms;
    Thumbnail thumbnail;
    String title;

    Pages({this.index, this.ns, this.pageid, this.terms, this.thumbnail, this.title});

    factory Pages.fromMap(Map<String, dynamic> json) {
        return Pages(
            index: json['index'],
            ns: json['ns'],
            pageid: json['pageid'],
            terms: json['terms'] != null ? Terms.fromJson(json['terms']) : Terms(),
            thumbnail: json['thumbnail'] != null ? Thumbnail.fromJson(json['thumbnail']) : Thumbnail(),
            title: json['title'],
        );
    }

    Map<String, dynamic> toMap() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['index'] = this.index;
        data['ns'] = this.ns;
        data['pageid'] = this.pageid;
        data['title'] = this.title;
        if (this.terms != null) {
            data['terms'] = this.terms.toJson();
        }

            data['thumbnail'] = this.thumbnail.toJson()??"";

        return data;
    }
}

class Terms {
    List<String> description;

    Terms({this.description});

    factory Terms.fromJson(Map<String, dynamic> json) {
        return Terms(
            description: json['description'] != null ? new List<String>.from(json['description']) : "",
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();

            data['description'] = this.description??"";

        return data;
    }
}

class Thumbnail {
    int height;
    String source;
    int width;

    Thumbnail({this.height, this.source, this.width});

    factory Thumbnail.fromJson(Map<String, dynamic> json) {
        return Thumbnail(
            height: json['height'],
            source: json['source'],
            width: json['width'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['height'] = this.height;
        data['source'] = this.source;
        data['width'] = this.width;
        return data;
    }
}

class Continue {
    String continues;
    int gpsoffset;

    Continue({this.continues, this.gpsoffset});

    factory Continue.fromJson(Map<String, dynamic> json) {
        return Continue(
            continues: json['continues'],
            gpsoffset: json['gpsoffset'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['continues'] = this.continues;
        data['gpsoffset'] = this.gpsoffset;
        return data;
    }
}