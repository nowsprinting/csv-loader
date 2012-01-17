#CsvLoader

CsvLoader is load csv file utility for Objective-C.

Input:

- Character encode is utf-8
- Comma separated.
- Line feed code is LF(\n). CR(\r) is ignored.
- First line is column name.
- see: 'testdata.csv'

Output:

- property 'rows' is NSArray as row data array.
- Row is NSDictionary, key is column name, value is column value.
- If column data is integer or double, set value into NSNumber object.
- Or other, set NAN into NSNumber object.


#License

Copyright 2010-2012 HUB Systems, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
