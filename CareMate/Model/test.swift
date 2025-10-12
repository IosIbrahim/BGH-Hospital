//
//  test.swift
//  CareMate
//
//  Created by Khabeer on 2/1/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

//package khabeer.com.doctordesktop.utilities.helper;
//
//import android.util.Log;
//
//import com.google.gson.Gson;
//import com.google.gson.GsonBuilder;
//import com.google.gson.reflect.TypeToken;
//
//import org.json.JSONArray;
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.lang.reflect.Type;
//import java.util.ArrayList;
//import java.util.List;
//
//public class GsonSerializer {
//    public static <T> List<T> serializeJsonArray(Class<T> clazz, JSONObject jsonObject, String tag) {
//        List<T> result = null;
//        try {
//            Gson gson = new GsonBuilder().create();
//            if (jsonObject.has(tag) && !jsonObject.getString(tag).equals("null") && !jsonObject.getString(tag).equals("null")) {
//                JSONObject tagJson = jsonObject.getJSONObject(tag);
//                if (tagJson.has(tag + "_ROW") && !tagJson.getString(tag + "_ROW").equals("") && !tagJson.get(tag + "_ROW").equals("null")) {
//                    Object o = tagJson.get(tag + "_ROW");
//                    if (o instanceof JSONObject) {
//                        T singleValue = gson.fromJson(o.toString(), clazz);
//                        result = new ArrayList<>();
//                        result.add(singleValue);
//                    } else if (o instanceof JSONArray) {
//                        JSONArray jsonArray = (JSONArray) o;
//                        Type token = new TypeToken<List<T>>() {
//                        }.getType();
//                        result = gson.fromJson(jsonArray.toString(), token);
//
//                    }
//                }
//            }
//        } catch (JSONException e) {
//            e.printStackTrace();
//        }
//        return result;
//    }
//
//    public static <T> T serializeObjectWrapped(Class<T> clazz, JSONObject jsonObject, String tag) {
//        T result = null;
//        try {
//            Gson gson = new GsonBuilder().create();
//            if (jsonObject.has(tag) && !jsonObject.getString(tag).equals("null") && !jsonObject.getString(tag).equals("null")) {
//                JSONObject tagJson = jsonObject.getJSONObject(tag);
//                if (tagJson.has(tag + "_ROW") && !tagJson.getString(tag + "_ROW").equals("") && !tagJson.get(tag + "_ROW").equals("null")) {
//
//
//                    result = gson.fromJson(tagJson.getString(tag + "_ROW"), clazz);
//
//                }
//            }
//        } catch (JSONException e) {
//            Log.d("exception", tag + e.getMessage());
//        }
//        return result;
//    }
//}
