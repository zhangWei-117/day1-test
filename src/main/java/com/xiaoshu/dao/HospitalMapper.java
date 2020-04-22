package com.xiaoshu.dao;

import com.xiaoshu.entity.Custom;
import com.xiaoshu.entity.Hospital;
import org.apache.ibatis.annotations.Select;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface HospitalMapper extends Mapper<Hospital> {
    @Select("SELECT SUBSTRING(h.address,1,3)NAME,SUM(num) num FROM hospital h GROUP BY SUBSTRING(h.address,1,3)")
    List<Custom> getTu();
}
