package ai.nextbillion.maps_flutter;

import java.util.ArrayList;
import java.util.List;

import ai.nextbillion.kits.geojson.Feature;
import ai.nextbillion.kits.geojson.FeatureCollection;
import ai.nextbillion.kits.geojson.Geometry;
import ai.nextbillion.kits.geojson.GeometryCollection;
import ai.nextbillion.kits.geojson.Point;
import ai.nextbillion.kits.turf.TurfMeasurement;
import ai.nextbillion.maps.geometry.LatLng;
import ai.nextbillion.maps.geometry.LatLngBounds;

public class GeoJSONUtils {
  public static LatLng toLatLng(Point point) {
    if (point == null) {
      return null;
    }
    return new LatLng(point.latitude(), point.longitude());
  }

  private static GeometryCollection toGeometryCollection(List<Feature> features) {
    ArrayList<Geometry> geometries = new ArrayList<>();
    geometries.ensureCapacity(features.size());
    for (Feature feature : features) {
      geometries.add(feature.geometry());
    }
    return GeometryCollection.fromGeometries(geometries);
  }

  public static LatLngBounds toLatLngBounds(FeatureCollection featureCollection) {
    List<Feature> features = featureCollection.features();

    double[] bbox = TurfMeasurement.bbox(toGeometryCollection(features));

    return LatLngBounds.from(bbox[3], bbox[2], bbox[1], bbox[0]);
  }
}
