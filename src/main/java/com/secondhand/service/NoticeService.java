package com.secondhand.service;

import com.secondhand.pojo.Notice;

import java.util.List;

public interface NoticeService {
    boolean addNotice(Notice notice);
    boolean updateNotice(Notice notice);
    boolean deleteNotice(Integer id);
    Notice getNoticeById(Integer id);
    List<Notice> getAllNotices(String keyword);
    List<Notice> getPublishedNotices();
    List<Notice> getCarouselNotices();
    void incrementViewCount(Integer id);
}