//
//  ZoodataDictModel.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi Yang. All rights reserved.
//

#import "ZooResultsModel.h"

@implementation ZooResultsModel

- (NSNumber *)a_id {
    if (!_a_id) {
        _a_id = maybe(self.dataDict[@"_id"], NSNumber);
    }
    return _a_id;
}

- (NSString *)a_Conservation {
    if (!_a_Conservation) {
        _a_Conservation = nonEmptyString(self.dataDict[@"A_Conservation"]);
    }
    return _a_Conservation;
}

- (NSString *)a_Distribution {
    if (!_a_Distribution) {
        _a_Distribution = nonEmptyString(self.dataDict[@"A_Distribution"]);
    }
    return _a_Distribution;
}

- (NSString *)a_Pic03_ALT {
    if (!_a_Pic03_ALT) {
        _a_Pic03_ALT = nonEmptyString(self.dataDict[@"A_Pic03_ALT"]);
    }
    return _a_Pic03_ALT;
}

- (NSString *)a_Vedio_URL {
    if (!_a_Vedio_URL) {
        _a_Vedio_URL = nonEmptyString(self.dataDict[@"A_Vedio_URL"]);
    }
    return _a_Vedio_URL;
}

- (NSString *)a_Name_En {
    if (!_a_Name_En) {
        _a_Name_En = nonEmptyString(self.dataDict[@"A_Name_En"]);
    }
    return _a_Name_En;
}

- (NSString *)a_Family {
    if (!_a_Family) {
        _a_Family = nonEmptyString(self.dataDict[@"A_Family"]);
    }
    return _a_Family;
}

- (NSString *)a_Voice02_URL {
    if (!_a_Voice02_URL) {
        _a_Voice02_URL = nonEmptyString(self.dataDict[@"A_Voice02_URL"]);
    }
    return _a_Voice02_URL;
}

- (NSString *)a_Geo {
    if (!_a_Geo) {
        _a_Geo = nonEmptyString(self.dataDict[@"A_Geo"]);
    }
    return _a_Geo;
}

- (NSString *)a_Behavior {
    if (!_a_Behavior) {
        _a_Behavior = nonEmptyString(self.dataDict[@"A_Behavior"]);
    }
    return _a_Behavior;
}

- (NSString *)a_Interpretation {
    if (!_a_Interpretation) {
        _a_Interpretation = nonEmptyString(self.dataDict[@"A_Interpretation"]);
    }
    return _a_Interpretation;
}

- (NSString *)a_pdf01_ALT {
    if (!_a_pdf01_ALT) {
        _a_pdf01_ALT = nonEmptyString(self.dataDict[@"A_pdf01_ALT"]);
    }
    return _a_pdf01_ALT;
}

- (NSString *)a_CID {
    if (!_a_CID) {
        _a_CID = nonEmptyString(self.dataDict[@"A_CID"]);
    }
    return _a_CID;
}

- (NSString *)a_Pic04_ALT {
    if (!_a_Pic04_ALT) {
        _a_Pic04_ALT = nonEmptyString(self.dataDict[@"A_Pic04_ALT"]);
    }
    return _a_Pic04_ALT;
}

- (NSString *)a_Pic01_URL {
    if (!_a_Pic01_URL) {
        _a_Pic01_URL = nonEmptyString(self.dataDict[@"A_Pic01_URL"]);
    }
    return _a_Pic01_URL;
}

- (NSString *)a_Summary {
    if (!_a_Summary) {
        _a_Summary = nonEmptyString(self.dataDict[@"A_Summary"]);
    }
    return _a_Summary;
}

- (NSString *)a_Order {
    if (!_a_Order) {
        _a_Order = nonEmptyString(self.dataDict[@"A_Order"]);
    }
    return _a_Order;
}

- (NSString *)a_Pic02_URL {
    if (!_a_Pic02_URL) {
        _a_Pic02_URL = nonEmptyString(self.dataDict[@"A_Pic02_URL"]);
    }
    return _a_Pic02_URL;
}

- (NSString *)a_pdf02_ALT {
    if (!_a_pdf02_ALT) {
        _a_pdf02_ALT = nonEmptyString(self.dataDict[@"A_pdf02_ALT"]);
    }
    return _a_pdf02_ALT;
}

- (NSString *)a_Voice02_ALT {
    if (!_a_Voice02_ALT) {
        _a_Voice02_ALT = nonEmptyString(self.dataDict[@"A_Voice02_ALT"]);
    }
    return _a_Voice02_ALT;
}

- (NSString *)a_Theme_Name {
    if (!_a_Theme_Name) {
        _a_Theme_Name = nonEmptyString(self.dataDict[@"A_Theme_Name"]);
    }
    return _a_Theme_Name;
}

- (NSString *)a_Name_Latin {
    if (!_a_Name_Latin) {
        _a_Name_Latin = nonEmptyString(self.dataDict[@"A_Name_Latin"]);
    }
    return _a_Name_Latin;
}

- (NSString *)a_Phylum {
    if (!_a_Phylum) {
        _a_Phylum = nonEmptyString(self.dataDict[@"A_Phylum"]);
    }
    return _a_Phylum;
}

- (NSString *)a_Class {
    if (!_a_Class) {
        _a_Class = nonEmptyString(self.dataDict[@"A_Class"]);
    }
    return _a_Class;
}

- (NSString *)a_Adopt {
    if (!_a_Adopt) {
        _a_Adopt = nonEmptyString(self.dataDict[@"A_Adopt"]);
    }
    return _a_Adopt;
}

- (NSString *)a_Voice03_URL {
    if (!_a_Voice03_URL) {
        _a_Voice03_URL = nonEmptyString(self.dataDict[@"A_Voice03_URL"]);
    }
    return _a_Voice03_URL;
}

- (NSString *)a_Keywords {
    if (!_a_Keywords) {
        _a_Keywords = nonEmptyString(self.dataDict[@"A_Keywords"]);
    }
    return _a_Keywords;
}

- (NSString *)a_Pic03_URL {
    if (!_a_Pic03_URL) {
        _a_Pic03_URL = nonEmptyString(self.dataDict[@"A_Pic03_URL"]);
    }
    return _a_Pic03_URL;
}

- (NSString *)a_Theme_URL {
    if (!_a_Theme_URL) {
        _a_Theme_URL = nonEmptyString(self.dataDict[@"A_Theme_URL"]);
    }
    return _a_Theme_URL;
}

- (NSString *)a_Code {
    if (!_a_Code) {
        _a_Code = nonEmptyString(self.dataDict[@"A_Code"]);
    }
    return _a_Code;
}

- (NSString *)a_Diet {
    if (!_a_Diet) {
        _a_Diet = nonEmptyString(self.dataDict[@"A_Diet"]);
    }
    return _a_Diet;
}

- (NSString *)a_pdf01_URL {
    if (!_a_pdf01_URL) {
        _a_pdf01_URL = nonEmptyString(self.dataDict[@"A_pdf01_URL"]);
    }
    return _a_pdf01_URL;
}

- (NSString *)a_AlsoKnown {
    if (!_a_AlsoKnown) {
        _a_AlsoKnown = nonEmptyString(self.dataDict[@"A_AlsoKnown"]);
    }
    return _a_AlsoKnown;
}

- (NSString *)a_Pic04_URL {
    if (!_a_Pic04_URL) {
        _a_Pic04_URL = nonEmptyString(self.dataDict[@"A_Pic04_URL"]);
    }
    return _a_Pic04_URL;
}

- (NSString *)a_POIGroup {
    if (!_a_POIGroup) {
        _a_POIGroup = nonEmptyString(self.dataDict[@"A_POIGroup"]);
    }
    return _a_POIGroup;
}

- (NSString *)a_Voice03_ALT {
    if (!_a_Voice03_ALT) {
        _a_Voice03_ALT = nonEmptyString(self.dataDict[@"A_Voice03_ALT"]);
    }
    return _a_Voice03_ALT;
}

- (NSString *)a_Location {
    if (!_a_Location) {
        _a_Location = nonEmptyString(self.dataDict[@"A_Location"]);
    }
    return _a_Location;
}

- (NSString *)a_Habitat {
    if (!_a_Habitat) {
        _a_Habitat = nonEmptyString(self.dataDict[@"A_Habitat"]);
    }
    return _a_Habitat;
}

- (NSString *)a_Voice01_URL {
    if (!_a_Voice01_URL) {
        _a_Voice01_URL = nonEmptyString(self.dataDict[@"A_Voice01_URL"]);
    }
    return _a_Voice01_URL;
}

- (NSString *)a_pdf02_URL {
    if (!_a_pdf02_URL) {
        _a_pdf02_URL = nonEmptyString(self.dataDict[@"A_pdf02_URL"]);
    }
    return _a_pdf02_URL;
}

- (NSString *)a_Pic01_ALT {
    if (!_a_Pic01_ALT) {
        _a_Pic01_ALT = nonEmptyString(self.dataDict[@"A_Pic01_ALT"]);
    }
    return _a_Pic01_ALT;
}

- (NSString *)a_Crisis {
    if (!_a_Crisis) {
        _a_Crisis = nonEmptyString(self.dataDict[@"A_Crisis"]);
    }
    return _a_Crisis;
}

- (NSString *)a_Name_Ch {
    if (!_a_Name_Ch) {
        _a_Name_Ch = nonEmptyString(self.dataDict[@"A_Name_Ch"]);
    }
    return _a_Name_Ch;
}

- (NSString *)a_Feature {
    if (!_a_Feature) {
        _a_Feature = nonEmptyString(self.dataDict[@"A_Feature"]);
    }
    return _a_Feature;
}

- (NSString *)a_Pic02_ALT {
    if (!_a_Pic02_ALT) {
        _a_Pic02_ALT = nonEmptyString(self.dataDict[@"A_Pic02_ALT"]);
    }
    return _a_Pic02_ALT;
}

- (NSString *)a_Voice01_ALT {
    if (!_a_Voice01_ALT) {
        _a_Voice01_ALT = nonEmptyString(self.dataDict[@"A_Voice01_ALT"]);
    }
    return _a_Voice01_ALT;
}

- (NSString *)a_Update {
    if (!_a_Update) {
        _a_Update = nonEmptyString(self.dataDict[@"A_Update"]);
    }
    return _a_Update;
}

@end
