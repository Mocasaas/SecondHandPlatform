package com.secondhand.mapper;

import com.secondhand.pojo.Notice;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface NoticeMapper {
    int insert(Notice notice);
    int update(Notice notice);
    int deleteById(Integer id);
    Notice selectById(Integer id);
    List<Notice> selectAll(@Param("keyword") String keyword);
    List<Notice> selectPublished();
    List<Notice> selectForCarousel();
    int incrementViewCount(Integer id);
}