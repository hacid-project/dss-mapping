def to_wkt:

    def coordinates_to_wkt:
        if type != "array" then
            error("Unsupported GeoJSON coordinates: \(.)")
        elif all(type == "number") then
            join(" ")
        else
            "(\(map(coordinates_to_wkt) | join(",")))"
        end;

    def collection_to_wkt:
        if length > 1 then
            "GEOMETRYCOLLECTION(\(map(to_wkt) | join(",")))"
        else
                .[0] | to_wkt
        end;

    if .type == "FeatureCollection" then
        .features | collection_to_wkt
    elif .type == "GeometryCollection" then
        .geometries | collection_to_wkt
    elif .type == "Feature" then
        .geometry | to_wkt
    elif .type == "Polygon" then
        "POLYGON\(.coordinates | coordinates_to_wkt)"
    else
        error("Unsupported GeoJSON type: \(.type)")
    end;
    