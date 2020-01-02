Table loadData(String path){
  Table t = loadTable(path, "header");
  return t;
}

float min(Table table, String prop) {
  float minVal = Float.MAX_VALUE;
  for (TableRow row : table.rows()) {
    float val = row.getFloat(prop);
    if (val<minVal) {
      minVal = val;
    }
  }
  return minVal;
}

float max(Table table, String prop) {
  float maxVal = Float.MIN_VALUE;
  for (TableRow row : table.rows()) {
    float val = row.getFloat(prop);
    if (val>maxVal) {
      maxVal = val;
    }
  }
  return maxVal;
}
