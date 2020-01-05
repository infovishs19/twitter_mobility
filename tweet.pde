
class Tweet  implements Comparable<Tweet> {
  float lon;
  float lat;
  String timeString;
  String dateTime;
  Date timestamp;
  float timelineMs = 0;
  float positionX;
  float positionY;

  Tweet(float lon, float lat, String timeString, Date timestamp, float timelineMs, float positionX, float positionY) {
    this.lon = lon;
    this.lat = lat;
    this.timeString = timeString;
    this.dateTime = timeString;
    this.timestamp = timestamp;
    this.timelineMs = timelineMs;
    this.positionX = positionX;
    this.positionY = positionY;
  }

  @Override
    public int compareTo(Tweet o) {
    return this.timestamp.compareTo(o.timestamp);
  }
}
