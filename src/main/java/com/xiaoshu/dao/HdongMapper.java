package com.xiaoshu.dao;

import com.xiaoshu.entity.Custom;
import com.xiaoshu.entity.Hdong;
import com.xiaoshu.entity.Hospital;
import org.apache.ibatis.annotations.Select;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface HdongMapper extends Mapper<Hdong> {
    @Select("SELECT * FROM hdong where sid is null")
    List<Hdong> geta();

    @Select("SELECT * FROM hdong where sid=#{id}")
    List<Hdong> getb(int id);

    @Select("SELECT * FROM hdong where sid=#{id}")
    List<Hdong> getc(int id);
}
