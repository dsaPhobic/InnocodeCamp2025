package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class LocationService {

    private static final String NOMINATIM_URL = "https://nominatim.openstreetmap.org/search";

    public String getCoordinatesFromAddress(String address) {
        try {
            String encodedAddress = URLEncoder.encode(address, "UTF-8");
            String urlStr = NOMINATIM_URL + "?q=" + encodedAddress + "&format=json&limit=1";

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            // Yêu cầu User-Agent hợp lệ
            conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Java NominatimService)");

            // Đọc phản hồi
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder jsonResult = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonResult.append(line);
            }
            reader.close();

            // Parse JSON
            Gson gson = new Gson();
            JsonArray results = gson.fromJson(jsonResult.toString(), JsonArray.class);
            if (results.size() > 0) {
                JsonObject location = results.get(0).getAsJsonObject();
                String lat = location.get("lat").getAsString();
                String lon = location.get("lon").getAsString();
                return lat + "," + lon;
            } else {
                return "Location not found!";
            }

        } catch (IOException e) {
            e.printStackTrace();
            return "Connecting error";
        }
    }

}
