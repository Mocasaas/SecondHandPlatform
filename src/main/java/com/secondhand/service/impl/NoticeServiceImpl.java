package com.secondhand.service.impl;

import com.secondhand.mapper.NoticeMapper;
import com.secondhand.pojo.Notice;
import com.secondhand.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeMapper noticeMapper;

    @Override
    public boolean addNotice(Notice notice) {
        return noticeMapper.insert(notice) > 0;
    }

    @Override
    public boolean updateNotice(Notice notice) {
        return noticeMapper.update(notice) > 0;
    }

    @Override
    public boolean deleteNotice(Integer id) {
        return noticeMapper.deleteById(id) > 0;
    }

    @Override
    public Notice getNoticeById(Integer id) {
        return noticeMapper.selectById(id);
    }

    @Override
    public List<Notice> getAllNotices(String keyword) {
        return noticeMapper.selectAll(keyword);
    }

    @Override
    public List<Notice> getPublishedNotices() {
        return noticeMapper.selectPublished();
    }

    @Override
    public List<Notice> getCarouselNotices() {
        return noticeMapper.selectForCarousel();
    }

    @Override
    public void incrementViewCount(Integer id) {
        noticeMapper.incrementViewCount(id);
    }
}