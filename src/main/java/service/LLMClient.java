package service;


import okhttp3.OkHttpClient;

public class LLMClient {
    private static final OkHttpClient client = new OkHttpClient();

    public static OkHttpClient getInstance() {
        return client;
    }

    public static void shutdown() {
        client.dispatcher().executorService().shutdown();
        client.connectionPool().evictAll();
    }
}