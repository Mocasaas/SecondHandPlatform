package com.secondhand.utils;

public class DataInfo {
    private Integer code;
    private String msg;
    private Object data;
    private Long count;

    public DataInfo() {
    }

    public DataInfo(Integer code, String msg, Object data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public DataInfo(Integer code, String msg, Object data, Long count) {
        this.code = code;
        this.msg = msg;
        this.data = data;
        this.count = count;
    }

    public static DataInfo ok() {
        return new DataInfo(0, "成功", null);
    }

    public static DataInfo ok(String msg) {
        return new DataInfo(0, msg, null);
    }

    public static DataInfo ok(Object data) {
        return new DataInfo(0, "成功", data);
    }

    public static DataInfo ok(String msg, Object data) {
        return new DataInfo(0, msg, data);
    }

    public static DataInfo ok(String msg, Long count, Object data) {
        return new DataInfo(0, msg, data, count);
    }

    public static DataInfo fail(String msg) {
        return new DataInfo(400, msg, null);
    }

    public static DataInfo fail(int code, String msg) {
        return new DataInfo(code, msg, null);
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }
}